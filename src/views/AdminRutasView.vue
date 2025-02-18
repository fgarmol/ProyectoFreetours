<script setup>
import { ref, computed, onMounted } from 'vue';
import router from '@/router';

const rutas = ref([]);
const paginaActual = ref(1);
const itemsPorPagina = 10; // Número de rutas por página

const showModalCrearRuta = ref(false);
const mostrarModalCrearRuta = () => {
    showModalCrearRuta.value = true;
};
const cerrarModalCrearRuta = () => {
    clearForm();
    showModalCrearRuta.value = false;
};
const loading = ref(true);

const newRuta = {
    titulo: '',
    localidad: '',
    descripcion: '',
    foto: '',
    fecha: '',
    hora: '',
    latitud: '',
    longitud: '',
    guia_id: ''
}

function showAlert(message, isSuccess = false) {
    const alert = document.getElementById('alert');
    alert.textContent = message;
    alert.style.display = 'block';
    alert.className = isSuccess ? 'alert success' : 'alert';
}

function clearForm() {
    newRuta.titulo = '';
    newRuta.localidad = '';
    newRuta.descripcion = '';
    newRuta.foto = '';
    newRuta.fecha = '';
    newRuta.hora = '';
    newRuta.latitud = '';
    newRuta.longitud = '';
    newRuta.guia_id = '';
}

function cargarRutas() {
    fetch("http://localhost/APIFreetours/api.php/rutas")
        .then(response => {
            if (!response.ok) {
                throw new Error(`Error ${response.status}: ${response.statusText}`);
            }
            return response.json();
        })
        .then(data => {
            rutas.value = data;
            console.log(data);
        })
        .catch(error => showAlert(`Error al obtener rutas: ${error.message}`));
}

onMounted(() => {
    cargarRutas();
});

function eliminarRuta(id) {
    if (confirm('¿Estás seguro de que deseas eliminar esta ruta?')) {
        fetch(`http://localhost/APIFreetours/api.php/rutas?id=${id}`, {
            method: 'DELETE'
        })
            .then(response => {
                if (!response.ok) {
                    throw new Error(`Error ${response.status}: ${response.statusText}`);
                }
                return response.json();
            })
            .then(data => {
                showAlert('Ruta eliminada correctamente', true);
                cargarRutas();
            })
            .catch(error => showAlert(`Error al eliminar ruta: ${error.message}`));
    }
}

function crearRuta() {
    const data = {
        titulo: newRuta.titulo,
        localidad: newRuta.localidad,
        descripcion: newRuta.descripcion,
        foto: newRuta.foto,
        fecha: newRuta.fecha,
        hora: newRuta.hora,
        latitud: newRuta.latitud,
        longitud: newRuta.longitud,
        guia_id: newRuta.guia_id
    };
    fetch("http://localhost/APIFreetours/api.php/rutas", {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json'
        },
        body: JSON.stringify(data)
    })
        .then(response => {
            if (!response.ok) {
                throw new Error(`Error ${response.status}: ${response.statusText}`);
            }
            return response.json();
        })
        .then(data => {
            showAlert('Ruta creada correctamente', true);
            cargarRutas();
            cerrarModalCrearRuta();
        })
        .catch(error => showAlert(`Error al crear ruta: ${error.message}`));
}

function asignarGuia(id) {
    newRuta.guia_id = id;
}

const rutasPaginadas = computed(() => {
    const inicio = (paginaActual.value - 1) * itemsPorPagina;
    const fin = inicio + itemsPorPagina;
    return rutas.value.slice(inicio, fin);
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
                    <th>Titulo</th>
                    <th>Localidad</th>
                    <th>Descripcion</th>
                    <th>Fecha</th>
                    <th>Hora</th>
                    <th>Latitud</th>
                    <th>Longitud</th>
                    <th>Guia</th>
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
                    <td>{{ ruta.guia_id }}</td>
                    <td>
                        <button @click="eliminarRuta(ruta.id)" class="btn btn-danger">Eliminar</button>
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
.container {
    padding-bottom: 5rem;
}

.pagination {
    display: flex;
    justify-content: center;
    align-items: center;
    margin-top: 1rem;
}

.pagination button {
    margin: 0 0.5rem;
}
</style>
