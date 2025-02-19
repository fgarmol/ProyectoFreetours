<script setup>
import { ref, onMounted } from 'vue';
import { useRoute } from 'vue-router';
import L from 'leaflet';
import 'leaflet/dist/leaflet.css';

const props = defineProps({
    usuarioAutenticado: {
        type: Object,
        required: true
    }
});

function showAlert(message, isSuccess = false) {
    const alert = document.getElementById('alert');
    alert.textContent = message;
    alert.style.display = 'block';
    alert.className = isSuccess ? 'alert success' : 'alert';
}

const ruta = ref(null);
const asistentes = ref(1);
const route = useRoute();
const rutaId = route.params.id;

function obtenerRuta() {
    fetch(`http://localhost/APIFreetours/api.php/rutas/?id=${rutaId}`)
        .then(response => response.json())
        .then(data => {
            console.log('Ruta:', data);
            ruta.value = data;
        })
        .catch(error => console.error('Error:', error));
}

onMounted(() => {
    obtenerRuta();
});

function reservar() {
    console.log('Reservar function called');
    const data = {
        ruta_id: rutaId,
        num_personas: asistentes.value,
        email: props.usuarioAutenticado.usuario.email
    };
    console.log('Data:', data);
    fetch("http://localhost/APIFreetours/api.php/reservas", {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json'
        },
        body: JSON.stringify(data)
    })
        .then(response => {
            if (!response.ok) throw new Error(`Error ${response.status}: ${response.statusText}`);
            console.log('Response:', response);
            return response.json();
        })
        .then(data => {
            console.log('Reserva:', data);
            showAlert('Reserva realizada exitosamente', true);
            obtenerRuta();
        })
        .catch(error => {
            showAlert(`Error al realizar la reserva: ${error.message}`, false);
        });
}

function formatDate(dateString) {
    const options = { day: '2-digit', month: '2-digit', year: 'numeric' };
    return new Date(dateString).toLocaleDateString('es-ES', options);
}

</script>

<template>
    <div v-if="ruta" class="container">
        <h1>{{ ruta.titulo }}</h1>
        <p>{{ ruta.descripcion }}</p>
        <p>Fecha: {{formatDate(ruta.fecha) }} </p>
        <p>Hora: {{ ruta.hora }}</p>
        <p>Localidad: {{ ruta.localidad }}</p>
        <p>Guía: {{ ruta.guia }}</p>
        <p>Asistentes: {{ ruta.asistentes }}</p>

        <form @submit.prevent="reservar" class="form">
            <div class="form-group mt-3">
            <label for="email">Email:&nbsp</label>
            <input type="email" v-model="usuarioAutenticado.usuario.email" disabled />
        </div>  
            <div class="form-group mt-3">
            <label for="asistentes">Cantidad de asistentes:&nbsp</label>
            <input type="number" id="asistentes" v-model="asistentes" min="1" />
        </div>
            <button type="submit">Reservar</button>
        </form>

        <div id="alert" class="alert"></div>
    </div>
    <div v-else>
        <p>Cargando información de la ruta...</p>
    </div>
</template>
