<script setup>
import { ref, computed, onMounted } from 'vue';
import dayjs from 'dayjs'; // Asegúrate de tener dayjs instalado

const props = defineProps({
    usuarioAutenticado: {
        type: Object,
        required: true
    }
});

const emit = defineEmits(['sesionIniciada']);

const rutas = ref([]);
const activeTab = ref('pendientes');
const guiasDisponibles = ref({});
const guiasDisponiblesModal = ref([]);
const sortKey = ref('');
const sortOrder = ref(1); // 1 for ascending, -1 for descending

const showModal = ref(false);
const paginaActual = ref(1);
const totalPaginas = ref(1);
const selectedRuta = ref(null);
const nuevaFecha = ref('');
const todasLasValoraciones = ref([]);

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

function obtenerValoraciones() {
    fetch(`http://localhost/APIFreetours/api.php/valoraciones`)
        .then(response => {
            if (!response.ok) throw new Error(`Error ${response.status}: ${response.statusText}`);
            return response.json();
        })
        .then(data => {
            try {
                todasLasValoraciones.value = data;
                console.log('Valoraciones cargadas:', todasLasValoraciones.value);
            } catch (error) {
                showAlert(`Error al procesar valoraciones: ${error.message}`);
            }
        })
        .catch(error => showAlert(`Error al obtener valoraciones: ${error.message}`));
}

function cargarRutas() {
    fetch("http://localhost/APIFreetours/api.php/rutas")
        .then(response => {
            if (!response.ok) throw new Error(`Error ${response.status}: ${response.statusText}`);
            return response.json();
        })
        .then(async data => {
            rutas.value = data;
            // Para cada ruta, cargar sus guías disponibles según la fecha
            rutas.value.forEach(ruta => {
                cargarGuia(ruta.fecha, ruta.id);
            });
            console.log('valoraciones:', todasLasValoraciones.value);




            console.log('Rutas cargadas:', rutas.value);
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

function cancelarRuta(rutaId) {

    if (!confirm('¿Estás seguro de que deseas cancelar esta ruta?')) return;
    fetch(`http://localhost/APIFreetours/api.php/rutas?id=${rutaId}`, {
        method: 'DELETE'
    })
        .then(response => {
            if (!response.ok) throw new Error(`Error ${response.status}: ${response.statusText}`);
            return response.json();
        })
        .then(() => {
            showAlert('Ruta cancelada correctamente', true);
            cargarRutas();
        })
        .catch(error => showAlert(`Error al cancelar ruta: ${error.message}`));
}

onMounted(() => {
    
    cargarRutas();
    
});

const rutasPendientes = computed(() => {
    return rutas.value.filter(ruta => dayjs(ruta.fecha).isAfter(dayjs()));
});

const rutasPasadas = computed(() => {
    return rutas.value.filter(ruta => dayjs(ruta.fecha).isBefore(dayjs()));
});

function sortBy(key) {
    if (sortKey.value === key) {
        sortOrder.value = -sortOrder.value;
    } else {
        sortKey.value = key;
        sortOrder.value = 1;
    }
    rutas.value.sort((a, b) => {
        let aValue = a[key];
        let bValue = b[key];

        // Convertir a números si la clave es 'id'
        if (key === 'id') {
            aValue = Number(aValue);
            bValue = Number(bValue);
        }

        if (typeof aValue === 'number' && typeof bValue === 'number') {
            return (aValue - bValue) * sortOrder.value;
        } else {
            return aValue.localeCompare(bValue) * sortOrder.value;
        }
    });
}



function calcularMediaValoraciones(valoraciones) {
    const totalValoraciones = valoraciones.length;
    if (totalValoraciones === 0) return 0;

    const sumaValoraciones = valoraciones.reduce((total, valoracion) => total + valoracion.valoracion, 0);
    return sumaValoraciones / totalValoraciones;
}


function openModal(ruta) {
    selectedRuta.value = ruta;
    showModal.value = true;
}

function closeModal() {
    showModal.value = false;
}

function duplicarRuta() {
    // Implementar la lógica para duplicar la ruta
    closeModal();
}

function paginaAnterior() {
    if (paginaActual.value > 1) {
        paginaActual.value--;
        cargarRutas();
    }
}

function paginaSiguiente() {
    if (paginaActual.value < totalPaginas.value) {
        paginaActual.value++;
        cargarRutas();
    }
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
            <span class="fw-bold">Total de rutas: {{ rutas.length }}</span>
        </div>

        <ul class="nav nav-tabs">
            <li class="nav-item">
                <a class="nav-link" :class="{ active: activeTab === 'pendientes' }"
                    @click="activeTab = 'pendientes'">Rutas Pendientes</a>
            </li>
            <li class="nav-item">
                <a class="nav-link" :class="{ active: activeTab === 'pasadas' }" @click="activeTab = 'pasadas'">Rutas
                    Pasadas</a>
            </li>
        </ul>

        <div class="tab-content">
            <div v-if="activeTab === 'pendientes'" class="tab-pane active">
                <table class="table">
                    <thead>
                        <tr>
                            <th @click="sortBy('id')">ID</th>
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
                        <tr v-for="ruta in rutasPendientes" :key="ruta.id">
                            <td>{{ ruta.id }}</td>
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
                                <button @click="cancelarRuta(ruta.id)" class="btn btn-danger">Eliminar</button>
                                <button @click="openModal(ruta)" class="btn btn-secondary">Duplicar</button>
                                <span v-if="ruta.asistentes < 10" class="text-warning">
                                    <i class="fas fa-exclamation-triangle"></i>❗
                                </span>

                            </td>
                        </tr>
                    </tbody>
                </table>
            </div>
            <div v-if="activeTab === 'pasadas'" class="tab-pane active">
                <table class="table">
                    <thead>
                        <tr>
                            <th @click="sortBy('id')">ID</th>
                            <th @click="sortBy('titulo')">Título</th>
                            <th @click="sortBy('localidad')">Localidad</th>
                            <th @click="sortBy('descripcion')">Descripción</th>
                            <th @click="sortBy('fecha')">Fecha</th>
                            <th @click="sortBy('hora')">Hora</th>
                            <th @click="sortBy('asistentes')">Asistentes</th>
                            <th>Media Valoraciones</th>
                            <th>Acciones</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr v-for="ruta in rutasPasadas" :key="ruta.id">
                            <td>{{ ruta.id }}</td>
                            <td>{{ ruta.titulo }}</td>
                            <td>{{ ruta.localidad }}</td>
                            <td>{{ ruta.descripcion }}</td>
                            <td>{{ ruta.fecha }}</td>
                            <td>{{ ruta.hora }}</td>
                            <td>{{ ruta.asistentes }}</td>
                            <td>
                                <span v-if="ruta.mediaValoraciones !== undefined && !isNaN(ruta.mediaValoraciones)">
                                    Media de valoraciones: {{ ruta.mediaValoraciones.toFixed(2) }}
                                </span>
                                <span v-else>
                                    No tiene valoraciones aún
                                </span>
                            </td>
                            <td>
                                <select v-model="ruta.guia_id" @change="asignarGuia(ruta)">
                                    <option disabled>Seleccionar guía</option>
                                    <option v-for="guia in obtenerGuias(ruta)" :key="guia.id" :value="guia.id">
                                        {{ guia.nombre }}
                                    </option>
                                </select>
                            </td>
                            <td>
                                <button @click="cancelarRuta(ruta.id)" class="btn btn-danger">Eliminar</button>
                                <button @click="openModal(ruta)" class="btn btn-secondary">Duplicar</button>
                            </td>
                        </tr>
                    </tbody>
                </table>
            </div>
        </div>

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
                            <option v-for="guia in guiasDisponiblesModal" :key="guia.id" :value="guia.id">{{ guia.nombre
                                }}</option>
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
