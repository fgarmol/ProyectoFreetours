<script setup>
import { ref, computed, onMounted } from 'vue';

const props = defineProps({
    usuarioAutenticado: {
        type: Object,
        required: true
    }
});

const emit = defineEmits(['sesionIniciada']);

const rutas = ref([]);
const paginaActual = ref(1);
const itemsPorPagina = 10;
const guiasDisponibles = ref({});
const guiasDisponiblesModal = ref([]);
const sortKey = ref('');
const sortOrder = ref(1); // 1 for ascending, -1 for descending

function showAlert(message, isSuccess = false) {
    const alert = document.getElementById('alert');
    alert.textContent = message;
    alert.style.display = 'block';
    alert.className = isSuccess ? 'alert success' : 'alert';
}

function cargarGuia(fecha, rutaId) {
    fetch(`http://localhost/APIFreetours/api.php/asignaciones?fecha=${fecha}`)
        .then(response => {
            if (!response.ok) throw new Error(`Error ${response.status}: ${response.statusText}`);
            return response.json();
        })
        .then(data => {
            guiasDisponibles.value[rutaId] = data;
            if (rutaId === selectedRuta.value?.id) {
                guiasDisponiblesModal.value = data;
            }
        })
        .catch(error => showAlert(`Error al cargar guías: ${error.message}`));
}

function cargarRutas() {
    fetch("http://localhost/APIFreetours/api.php/rutas")
        .then(response => {
            if (!response.ok) throw new Error(`Error ${response.status}: ${response.statusText}`);
            return response.json();
        })
        .then(data => {
            rutas.value = data;
            // Para cada ruta, cargar sus guías disponibles según la fecha
            rutas.value.forEach(ruta => {
                cargarGuia(ruta.fecha, ruta.id);
            });
        })
        .catch(error => showAlert(`Error al obtener rutas: ${error.message}`));
}

function asignarGuia(ruta) {
    const data = {
        guia_id: ruta.guia_id,
        ruta_id: ruta.id
    };

    fetch("http://localhost/APIFreetours/api.php/asignaciones", {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json'
        },
        body: JSON.stringify(data)
    })
        .then(response => {
            if (!response.ok) throw new Error(`Error ${response.status}: ${response.statusText}`);
            return response.json();
        })
        .then(() => {
            showAlert('Guía asignado correctamente', true);

            cargarRutas();

        })
        .catch(error => showAlert(`Error al asignar guía: ${error.message}`));
}


function obtenerGuias(ruta) {
    const disponibles = guiasDisponibles.value[ruta.id] || [];
    if (ruta.guia_id) {
        const existe = disponibles.find(g => g.id === ruta.guia_id);
        if (!existe) {

            return [{ id: ruta.guia_id, nombre: ruta.guia_nombre || 'Sin nombre' }, ...disponibles];
        }
    }
    return disponibles;
}

onMounted(() => {
    cargarRutas();
});

const rutasPaginadas = computed(() => {
    const inicio = (paginaActual.value - 1) * itemsPorPagina;
    return rutas.value.slice(inicio, inicio + itemsPorPagina);
});

const totalPaginas = computed(() => {
    return Math.ceil(rutas.value.length / itemsPorPagina);
});

function paginaSiguiente() {
    if (paginaActual.value < totalPaginas.value) {
        paginaActual.value++;
    }
}

function paginaAnterior() {
    if (paginaActual.value > 1) {
        paginaActual.value--;
    }
}

const showModal = ref(false);
const selectedRuta = ref(null);
const nuevaFecha = ref('');

function openModal(ruta) {
    selectedRuta.value = ruta;
    nuevaFecha.value = ruta.fecha;
    showModal.value = true;
    cargarGuia(nuevaFecha.value, ruta.id);
}

function closeModal() {
    showModal.value = false;
    selectedRuta.value = null;
    nuevaFecha.value = '';
    guiasDisponiblesModal.value = [];
}



function eliminarRuta(id) {
    if (!confirm('¿Estás seguro de que deseas eliminar esta ruta?')) {
        return;
    }
    fetch(`http://localhost/APIFreetours/api.php/rutas?id=${id}`, {
        method: 'DELETE',
    })
        .then(response => {
            if (!response.ok) {
                throw new Error(`Error ${response.status}: ${response.statusText}`);
            }
            return response.json();
        })
        .then(responseData => {
            showAlert('Ruta eliminada exitosamente', true);
            cargarRutas();
        })
        .catch(error => showAlert(`Error al eliminar la ruta: ${error.message}`, false));
}


function duplicarRuta() {
    if (selectedRuta.value) {
        const data = {
            titulo: selectedRuta.value.titulo,
            localidad: selectedRuta.value.localidad,
            descripcion: selectedRuta.value.descripcion,
            foto: selectedRuta.value.foto,
            fecha: nuevaFecha.value,
            hora: selectedRuta.value.hora,
            latitud: selectedRuta.value.latitud,
            longitud: selectedRuta.value.longitud,
            guia_id: selectedRuta.value.guia_id
        };

        fetch("http://localhost/APIFreetours/api.php/rutas", {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify(data)
        })
            .then(response => {
                if (!response.ok) throw new Error(`Error ${response.status}: ${response.statusText}`);
                return response.json();
            })
            .then(() => {
                showAlert('Ruta duplicada correctamente', true);
                cargarRutas();
                closeModal();
            })
            .catch(error => showAlert(`Error al duplicar ruta: ${error.message}`));
    }
}

const totalRutas = computed(() => rutas.value.length);

function sortBy(key) {
    if (sortKey.value === key) {
        sortOrder.value = -sortOrder.value;
    } else {
        sortKey.value = key;
        sortOrder.value = 1;
    }
    rutas.value.sort((a, b) => {
        if (a[key] < b[key]) return -sortOrder.value;
        if (a[key] > b[key]) return sortOrder.value;
        return 0;
    });
}

</script>

<template>
    <div class="container">
        <h1>Administrar rutas</h1>
        <div id="alert" class="alert"></div>
        <div>
            <router-link to="/admin/rutas/crearRuta" class="btn btn-primary">Crear ruta</router-link>
        </div>

        <div class="counters d-flex justify-content-end">
            <span class="fw-bold">Total de rutas: {{ totalRutas }}</span>
        </div>
        <table class="table">
            <thead>
                <tr>
                    <th @click="sortBy('titulo')">Título</th>
                    <th @click="sortBy('localidad')">Localidad</th>
                    <th @click="sortBy('descripcion')">Descripción</th>
                    <th @click="sortBy('fecha')">Fecha</th>
                    <th @click="sortBy('hora')">Hora</th>
                    <th @click="sortBy('latitud')">Latitud</th>
                    <th @click="sortBy('longitud')">Longitud</th>
                    <th>Guía</th>
                    <th>Acciones</th>
                </tr>
            </thead>
            <tbody>
                <tr v-for="ruta in rutasPaginadas" :key="ruta.id">
                    <td>{{ ruta.titulo }}</td>
                    <td>{{ ruta.localidad }}</td>
                    <td>{{ ruta.descripcion }}</td>
                    <td>{{ ruta.fecha }}</td>
                    <td>{{ ruta.hora }}</td>
                    <td>{{ ruta.latitud }}</td>
                    <td>{{ ruta.longitud }}</td>
                    <td>
                        <select v-model="ruta.guia_id" @change="asignarGuia(ruta)">
                            <option disabled>Seleccionar guía</option>
                            <option v-for="guia in obtenerGuias(ruta)" :key="guia.id" :value="guia.id">
                                {{ guia.nombre }}
                            </option>
                        </select>
                    </td>
                    <td>
                        <button @click="eliminarRuta(ruta.id)" class="btn btn-danger">Eliminar</button>
                        <button @click="openModal(ruta)" class="btn btn-secondary">Duplicar</button>
                    </td>
                </tr>
            </tbody>
        </table>
        <div class="pagination">
            <button @click="paginaAnterior" :disabled="paginaActual === 1">Anterior</button>
            <span>Página {{ paginaActual }} de {{ totalPaginas }}</span>
            <button @click="paginaSiguiente" :disabled="paginaActual === totalPaginas">Siguiente</button>
        </div>
    </div>

    <div v-if="showModal" class="modal" tabindex="-1" role="dialog" style="display: block;">
        <div class="modal-dialog" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">Duplicar Ruta</h5>
                    <button type="button" class="close" @click="closeModal" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <div class="modal-body">
                    <div class="form-group">
                        <label for="nuevaFecha">Nueva Fecha</label>
                        <input type="date" id="nuevaFecha" v-model="nuevaFecha" class="form-control"
                            @change="cargarGuia(nuevaFecha, selectedRuta.id)">
                    </div>
                    <div class="form-group">
                        <label for="guia">Guía</label>
                        <select class="form-control" id="guia" v-model="selectedRuta.guia_id">
                            <option v-for="guia in guiasDisponiblesModal" :key="guia.id" :value="guia.id">{{ guia.nombre }}</option>
                        </select>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" @click="closeModal">Cerrar</button>
                    <button type="button" class="btn btn-primary" @click="duplicarRuta">Duplicar Ruta</button>
                </div>
            </div>
        </div>
    </div>
</template>

<style scoped>
.container {
    padding-bottom: 5rem;
}

.modal {
    background: rgba(0, 0, 0, 0.5);
    position: fixed;
    top: 0;
    left: 0;
    width: 100%;
    height: 100%;
    display: flex;
    align-items: center;
    justify-content: center;
}

.counters {
    margin: 1rem 0;
}
</style>
