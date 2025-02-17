<script setup>
import { ref, onMounted } from 'vue';

/* const rutas = ref([]);*/
const users = ref([]);
const guias = ref([]);

function showAlert(message, isSuccess = false) {
    const alert = document.getElementById('alert');
    alert.textContent = message;
    alert.style.display = 'block';
    alert.className = isSuccess ? 'alert success' : 'alert';
}   

const newRuta = ref({
    titulo: '',
    localidad: '',
    descripcion: '',
    foto: '',
    fecha: '',
    hora: '',
    latitud: '',
    longitud: '',
    guia_id: ''
});

function clearForm() {
    newRuta.value = {
        titulo: '',
        localidad: '',
        descripcion: '',
        foto: '',
        fecha: '',
        hora: '',
        latitud: '',
        longitud: '',
        guia_id: ''
    };
}

function cargarUsuarios() {
    fetch("http://localhost/APIFreetours/api.php/usuarios")
        .then(response => {
            if (!response.ok) {
                throw new Error(`Error ${response.status}: ${response.statusText}`);
            }
            return response.json();
        })
        .then(data => {
            users.value = data;
            console.log(data);
            filtrarGuia();
        })
        .catch(error => showAlert(`Error al obtener usuarios: ${error.message}`));
}

onMounted(() => {
    cargarUsuarios();
});

function filtrarGuia() {
  guias.value = users.value.filter(usuario => usuario.rol === 'guia');
}

function crearRuta() {
    const data = {
        titulo: newRuta.value.titulo,
        localidad: newRuta.value.localidad,
        descripcion: newRuta.value.descripcion,
        foto: newRuta.value.foto,
        fecha: newRuta.value.fecha,
        hora: newRuta.value.hora,
        latitud: newRuta.value.latitud,
        longitud: newRuta.value.longitud,
        guia_id: newRuta.value.guia_id
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
            clearForm();
        })
        .catch(error => showAlert(`Error al crear ruta: ${error.message}`));
}
</script>

<template>
    <div class="container">
        <div id="alert" class="alert"></div>
        <h1 class="m-3">Crear Ruta</h1>
    <form @submit.prevent="crearRuta" class="form m-3">
        <div class="form-group">
            <label for="titulo">Título</label>
            <input type="text" class="form-control" id="titulo" v-model="newRuta.titulo">
        </div>
        <div class="form-group">
            <label for="localidad">Localidad</label>
            <input type="text" class="form-control" id="localidad" v-model="newRuta.localidad">
        </div>
        <div class="form-group">
            <label for="descripcion">Descripción</label>
            <textarea class="form-control" id="descripcion" rows="3" v-model="newRuta.descripcion"></textarea>
        </div>
        <div class="form-group">
            <label for="foto">Foto</label>
            <input type="text" class="form-control" id="foto" v-model="newRuta.foto">
        </div>
        <div class="form-group">
            <label for="fecha">Fecha</label>
            <input type="date" class="form-control" id="fecha" v-model="newRuta.fecha">
        </div>
        <div class="form-group">
            <label for="hora">Hora</label>
            <input type="time" class="form-control" id="hora" v-model="newRuta.hora">
        </div>
        <div class="form-group">
            <label for="latitud">Latitud</label>
            <input type="text" class="form-control" id="latitud" v-model="newRuta.latitud">
        </div>
        <div class="form-group">
            <label for="longitud">Longitud</label>
            <input type="text" class="form-control" id="longitud" v-model="newRuta.longitud">
        </div>
        <div class="form-group">
            <label for="guia">Guía</label>
            <!-- tengo que arreglar esto -->
            <select class="form-control" id="guia" v-model="newRuta.guia_id">
                <option v-for="guia in guias" :key="guia.id" :value="guia.id">{{ guia.nombre }}: {{ guia.id }}</option>
            </select>
        </div>
        <button type="submit" class="btn btn-primary">Crear</button>
    </form>
    </div>
</template>

<style scoped>
.container {
    padding-bottom: 5rem;
}

</style>