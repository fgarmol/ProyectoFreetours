<script setup>
import { ref, computed, onMounted } from 'vue';

const rutas = ref([]);
const paginaActual = ref(1);
const itemsPorPagina = 10;
const guiasDisponibles = ref({});

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

function duplicarRuta(ruta) {
    const data = {
        titulo: ruta.titulo,
        localidad: ruta.localidad,
        descripcion: ruta.descripcion,
        foto: ruta.foto,
        fecha: ruta.fecha,
        hora: ruta.hora,
        latitud: ruta.latitud,
        longitud: ruta.longitud,
        guia_id: ruta.guia_id
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
        })
        .catch(error => showAlert(`Error al duplicar ruta: ${error.message}`));
}




</script>

<template>
    <div class="container">
        <h1>Administrar rutas</h1>
        <div>
            <router-link to="/admin/rutas/crearRuta" class="btn btn-primary">Crear ruta</router-link>
        </div>
        <div id="alert" class="alert"></div>
        <table class="table">
            <thead>
                <tr>
                    <th>Título</th>
                    <th>Localidad</th>
                    <th>Descripción</th>
                    <th>Fecha</th>
                    <th>Hora</th>
                    <th>Latitud</th>
                    <th>Longitud</th>
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
                            <option value="">Seleccionar guía</option>
                            <option v-for="guia in obtenerGuias(ruta)" :key="guia.id" :value="guia.id">
                                {{ guia.nombre }}
                            </option>
                        </select>
                    </td>
                    <td>
                        <button @click="eliminarRuta(ruta.id)" class="btn btn-danger">Eliminar</button>
                        <button @click="duplicarRuta(ruta)" class="btn btn-secondary">Duplicar</button>
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
</template>

<style scoped>
.container{
    padding-bottom: 5rem;
}


</style>
