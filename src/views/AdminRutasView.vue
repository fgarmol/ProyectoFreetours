<script setup>
import { ref, onMounted } from 'vue';
import router from '@/router';

const rutas = ref([]);
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
                <tr v-for="ruta in rutas" :key="ruta.id">
                    <td>{{ ruta.titulo }}</td>
                    <td>{{ ruta.localidad }}</td>
                    <td>{{ ruta.descripcion }}</td>
                    <td>{{ ruta.fecha }}</td>
                    <td>{{ ruta.hora }}</td>
                    <td>{{ ruta.latitud }}</td>
                    <td>{{ ruta.longitud }}</td>
                    <td>{{ ruta.guia_id }}</td>
                    <td>
                        <button @click="eliminarRuta(ruta.id)">Eliminar</button>
                    </td>
                </tr>
            </tbody>
        </table>
        <!-- <div v-if="showModalCrearRuta" class="modal" style="display: block;">
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title">Crear ruta</h5>
                        <button @click="cerrarModalCrearRuta" type="button" class="btn-close"></button>
                    </div>
                    <div class="modal-body">
                        <form @submit.prevent="crearRuta" class="form">
                            <div class="mb-3">
                                <label class="form-label" for="titulo">Titulo</label>
                                <input v-model="newRuta.titulo" type="text" id="titulo" class="form-control">
                            </div>
                            <div class="mb-3">
                                <label class="form-label" for="localidad">Localidad</label>
                                <input v-model="newRuta.localidad" type="text" id="localidad" class="form-control">
                            </div>
                            <div class="mb-3">
                                <label class="form-label" for="descripcion">Descripcion</label>
                                <input v-model="newRuta.descripcion" type="text" id="descripcion" class="form-control">
                            </div>
                            <div class="mb-3">
                                <label class="form-label" for="foto">Foto</label>
                                <input v-model="newRuta.foto" type="text" id="foto" class="form-control">
                            </div>
                            <div class="mb-3">
                                <label class="form-label" for="fecha">Fecha</label>
                                <input v-model="newRuta.fecha" type="date" id="fecha" class="form-control">
                            </div>
                            <div class="mb-3">
                                <label class="form-label" for="hora">Hora</label>
                                <input v-model="newRuta.hora" type="time" id="hora" class="form-control">
                            </div>
                            <div class="mb-3">
                                <label class="form-label" for="latitud">Latitud</label>
                                <input v-model="newRuta.latitud" type="text" id="latitud" class="form-control">
                            </div>
                            <div class="mb-3">
                                <label class="form-label" for="longitud">Longitud</label>
                                <input v-model="newRuta.longitud" type="text" id="longitud" class="form-control">
                            </div>
                            <div class="mb-3">
                                <label class="form-label" for="guia">Guia</label>
                                <select v-model="newRuta.guia_id" id="guia" class="form-select">
                                    <option v-for="guia in guias" :key="guia.id" :value="guia.id">{{ guia.nombre }}</option>
                                </select>
                            </div>
                            <button type="submit" class="btn btn-primary">Crear</button>
                        </form>
                    </div>
                </div>
            </div>
        </div>-->
    </div> 




</template>

<style scooped>
.container {
    padding-bottom: 5rem;
}
</style>
