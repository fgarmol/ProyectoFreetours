<script setup>
import { ref, computed, onMounted } from 'vue';
import dayjs from 'dayjs'; // Asegúrate de tener dayjs instalado
import router from '@/router';



const props = defineProps({
    usuarioAutenticado: Object
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
const mediasValoraciones = ref([]);
const mediasCalculadas = ref([]);



function showAlert(message, isSuccess = false) {
    $.notify({
        message: message
    }, {
        type: isSuccess ? 'success' : 'danger',
        delay: 2000,
        placement: {
            from: "bottom",
            align: "right"
        },
        animate: {
            enter: 'animated slideInUp',
            exit: 'animated slideOutDown'
        }
    });
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
            // Intentar procesar la respuesta incluso si hay un error
            return response.json().catch(() => {
                throw new Error(`Error ${response.status}: ${response.statusText}`);
            });
        })
        .then(data => {
            try {
                todasLasValoraciones.value = data;
                /* console.log('Valoraciones cargadas:', todasLasValoraciones.value); */
                mediasValoraciones.value = calcularMedia(); // Llamar a calcularMedia después de obtener las valoraciones
                /* console.log('Medias calculadas:', mediasValoraciones.value); */
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
/*             console.log('Rutas cargadas:', rutas.value);
 */            obtenerValoraciones();
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

    if (props.usuarioAutenticado.autenticado && props.usuarioAutenticado.usuario.rol === 'admin') {
        cargarRutas();
    } else {
        router.push('/');
    }


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

function calcularMedia() {
    const medias = [];

    // Recorremos todas las valoraciones
    todasLasValoraciones.value.forEach(valoracion => {
        const rutaId = valoracion.ruta_id;

        // Verificamos si ya hemos calculado la media para esta ruta
        if (!medias.some(media => media.ruta_id === rutaId)) {
            // Filtramos las valoraciones para la ruta actual
            const valoracionesRuta = todasLasValoraciones.value.filter(v => v.ruta_id === rutaId);
            /* console.log(`Valoraciones para ruta ${rutaId}:`, valoracionesRuta); */

            if (valoracionesRuta.length > 0) {
                // Sumamos las puntuaciones
                const sumaValoraciones = valoracionesRuta.reduce((acc, v) => acc + v.puntuacion, 0);
                // Calculamos la media
                const media = sumaValoraciones / valoracionesRuta.length;

                // Guardamos la media calculada
                medias.push({ ruta_id: rutaId, media });
            }
        }
    });

    console.log('Medias calculadas:', medias);

    // Guardamos las medias en el estado global
    mediasCalculadas.value = medias;
    return medias;
}

function obtenerMedia(idruta) {
    // Convertir el id a número para asegurar la comparación
    const id = Number(idruta);
    /* console.log('Medias almacenadas en mediasCalculadas:', mediasCalculadas.value); */
    const media = mediasCalculadas.value.find(item => item.ruta_id === id);
    if (!media) {
        /* console.log(`No se encontró media para la ruta ${idruta}`); */
    }
    return media ? media.media : null;
}




function duplicarRuta() {

    const nuevaRuta = {
        titulo: selectedRuta.value.titulo,
        localidad: selectedRuta.value.localidad,
        descripcion: selectedRuta.value.descripcion,
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
        body: JSON.stringify(nuevaRuta)
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

function openModal(ruta) {
    selectedRuta.value = ruta;
    nuevaFecha.value = '';
    guiasDisponiblesModal.value = guiasDisponibles.value[ruta.id] || [];
    showModal.value = true;
}

function closeModal() {
    showModal.value = false;
}

</script>

<template>
    <div class="container">
        <h1>Administrar rutas</h1>

        <div class="mb-3">
            <router-link to="/admin/rutas/crearRuta" class="btn btn-secondary">Crear ruta</router-link>
        </div>

        <div class="counters d-flex justify-content-end mb-3">
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
                <div class="table-responsive">
                    <table class="table">
                        <thead>
                            <tr>
                                <th @click="sortBy('id')">ID</th>
                                <th @click="sortBy('titulo')">Título</th>
                                <th @click="sortBy('localidad')">Localidad</th>
                                <th @click="sortBy('descripcion')">Descripción</th>
                                <th @click="sortBy('asistentes')">Asistentes</th>
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
                                <td>{{ ruta.asistentes }} <span v-if="ruta.asistentes < 10" class="text-warning">
                                        <i class="fas fa-exclamation-triangle"></i>❗>10</span>
                                </td>
                                <td>{{ ruta.fecha }}</td>
                                <td>{{ ruta.hora }}</td>
                                <td>{{ ruta.latitud }}</td>
                                <td>{{ ruta.longitud }}</td>
                                <td>
                                    <select v-model="ruta.guia_id" @change="asignarGuia(ruta)" class="form-select">
                                        <option disabled>Seleccionar guía</option>
                                        <option v-for="guia in obtenerGuias(ruta)" :key="guia.id" :value="guia.id">
                                            {{ guia.nombre }}
                                        </option>
                                    </select>
                                </td>
                                <td>
                                    <button @click="cancelarRuta(ruta.id)"
                                        class="btn btn-danger btn-sm">Eliminar</button>
                                    <button @click="openModal(ruta)" class="btn btn-secondary btn-sm">Duplicar</button>
                                </td>
                            </tr>
                        </tbody>
                    </table>
                </div>
            </div>
            <div v-if="activeTab === 'pasadas'" class="tab-pane active">
                <div class="table-responsive">
                    <table class="table">
                        <thead>
                            <tr>
                                <th @click="sortBy('id')">ID</th>
                                <th @click="sortBy('titulo')">Título</th>
                                <th @click="sortBy('localidad')">Localidad</th>
                                <th @click="sortBy('descripcion')">Descripción</th>
                                <th @click="sortBy('asistentes')">Asistentes</th>
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
                                <td>{{ ruta.asistentes }}</td>
                                <td>{{ ruta.fecha }}</td>
                                <td>{{ ruta.hora }}</td>
                                <td>{{ ruta.asistentes }}</td>
                                <td>
                                    <span v-if="(media = obtenerMedia(ruta.id)) !== null">
                                        Media de valoraciones: {{ media.toFixed(2) }}
                                    </span>
                                    <span v-else>
                                        No tiene valoraciones aún
                                    </span>
                                </td>
                                <td>
                                    <select v-model="ruta.guia_id" @change="asignarGuia(ruta)" class="form-control">
                                        <option disabled>Seleccionar guía</option>
                                        <option v-for="guia in obtenerGuias(ruta)" :key="guia.id" :value="guia.id">
                                            {{ guia.nombre }}
                                        </option>
                                    </select>
                                </td>
                                <td>
                                    <button @click="cancelarRuta(ruta.id)"
                                        class="btn btn-danger btn-sm me-2 mb-2">Eliminar</button>
                                    <button @click="openModal(ruta)"
                                        class="btn btn-secondary btn-sm mb-2">Duplicar</button>
                                </td>
                            </tr>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>

        <div class="pagination d-flex justify-content-center mt-3">
            <button @click="paginaAnterior" :disabled="paginaActual === 1"
                class="btn btn-secondary me-2">Anterior</button>
            <span class="align-self-center">Página {{ paginaActual }} de {{ totalPaginas }}</span>
            <button @click="paginaSiguiente" :disabled="paginaActual === totalPaginas"
                class="btn btn-secondary ms-2">Siguiente</button>
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
                    <button type="button" class="btn btn-secondary" @click="duplicarRuta">Duplicar Ruta</button>
                </div>
            </div>
        </div>
    </div>
</template>

<style scoped>
@import '@/assets/styles/main.css';

.nav-link.active {
    background-color: black !important;

    color: white !important;

}
</style>
