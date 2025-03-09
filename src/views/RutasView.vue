<script setup>
import { ref, onMounted, nextTick } from 'vue';
import { useRoute } from 'vue-router';
import 'bootstrap/dist/css/bootstrap.min.css';
import 'bootstrap-notify';
import L from 'leaflet';
import 'leaflet/dist/leaflet.css';

const props = defineProps({
    usuarioAutenticado: {
        type: Object,
        required: true
    }
});

const emit = defineEmits(['sesionIniciada']);

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
            // Utiliza nextTick para asegurarse de que el DOM se haya actualizado antes de inicializar el mapa con las coordenadas proporcionadas
            nextTick(() => {
                initMap(data.latitud, data.longitud); // Inicializa el mapa con las coordenadas
            });
        })
        .catch(error => {
            console.error('Error:', error);
            showAlert('Error al obtener la ruta', false);
        });
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
            if (data.status === 'success') {
                showAlert('Reserva realizada exitosamente', true);
                obtenerRuta();
            } else {
                showAlert(data.message, false);
            }
        })
        .catch(error => {
            showAlert(`Error al realizar la reserva: ${error.message}`, false);
        });
}

function formatDate(dateString) {
    const options = { day: '2-digit', month: '2-digit', year: 'numeric' };
    return new Date(dateString).toLocaleDateString('es-ES', options);
}

function initMap(lat, lng) {
    const map = L.map('map').setView([lat, lng], 13);
    L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
        attribution: '&copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors'
    }).addTo(map);
    L.marker([lat, lng]).addTo(map)
        .bindPopup('Punto de encuentro')
        .openPopup();
}
</script>

<template>
    <div v-if="ruta" class="container">
        <div class="d-flex align-items-start">
            <!-- título, descripción, fecha, hora, localidad, guía y asistentes de la ruta -->
            <div class="me-3">
                <h1>{{ ruta.titulo }}</h1>
                <p>{{ ruta.descripcion }}</p>
                <p>Fecha: {{ formatDate(ruta.fecha) }} </p>
                <p>Hora: {{ ruta.hora }}</p>
                <p>Localidad: {{ ruta.localidad }}</p>
                <p>Guía: {{ ruta.guia }}</p>
                <p>Asistentes: {{ ruta.asistentes }}</p>
            </div>
            <!-- imagen de la ruta -->
            <div class="foto h-100">
                <img :src="ruta.foto" alt="Foto de la ruta" class="img-fluid mb-3" />
            </div>
        </div>

        <div id="map" class="full-width" style="height: 400px;"></div> <!-- Contenedor del mapa -->

        <div v-if="props.usuarioAutenticado.autenticado">
            <form @submit.prevent="reservar" class="form">
                <div class="form-group mt-3">
                    <label for="email">Email:&nbsp</label>
                    <input type="email" v-model="props.usuarioAutenticado.usuario.email" class="form-control"
                        disabled />
                </div>
                <div class="form-group mt-3">
                    <label for="asistentes">Cantidad de asistentes:&nbsp</label>
                    <input type="number" id="asistentes" v-model="asistentes" class="form-control" min="1" />
                </div>
                <button type="submit" class="btn btn-primary">Reservar</button>
            </form>
        </div>
        <div v-else class="alert alert-danger">
            <p class="alert">Debes iniciar sesión para reservar una ruta</p>
        </div>
    </div>
</template>

<style scoped>
body {
    background-color: white;
    /* Fondo blanco */
    color: black;
    /* Texto negro */
}

.container {
    padding-bottom: 5rem;
    background-color: white;
    /* Fondo blanco */
    color: black;
    /* Texto negro */
}

h1,
p {
    color: black;
    /* Texto negro */
}

.form-group {
    margin-bottom: 1rem;
}

label {
    color: black;
    /* Texto negro */
    font-weight: bold;
}

input {
    background-color: white;
    /* Fondo blanco */
    color: black;
    /* Texto negro */
    border: 1px solid black;
    /* Borde negro */
    transition: border-color 0.3s ease, box-shadow 0.3s ease;
    /* Transición suave */
}

input:focus {
    border-color: black;
    /* Borde negro al enfocar */
    box-shadow: 0 0 5px rgba(0, 0, 0, 0.1);
    /* Sombra suave */
}

.btn-primary {
    background-color: black;
    /* Fondo negro */
    color: white;
    /* Texto blanco */
    border: none;
    /* Sin borde */
    transition: background-color 0.3s ease, color 0.3s ease;
    /* Transición suave */
}

.btn-primary:hover {
    background-color: white;
    /* Fondo blanco al pasar el ratón */
    color: black;
    /* Texto negro al pasar el ratón */
}

.alert {
    background-color: black;
    /* Fondo negro */
    color: white;
    /* Texto blanco */
    border: none;
    /* Sin borde */
    transition: opacity 0.3s ease;
    /* Transición suave */
}

.full-width {
    width: 100%;
}


</style>