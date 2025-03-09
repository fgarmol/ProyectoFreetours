<script setup>
import { ref, onMounted, nextTick } from 'vue';
import { useRoute } from 'vue-router';
import router from '@/router';
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

                // Redirige a la página principal con un timeout de 2 segundos
                setTimeout(() => router.push('/'), 2000);
                
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
        <div class="row">
            <!-- título, descripción, fecha, hora, localidad, guía y asistentes de la ruta -->
            <div class="col-md-8">
                <h1>{{ ruta.titulo }}</h1>
                <p>{{ ruta.descripcion }}</p>
                <p>Fecha: {{ formatDate(ruta.fecha) }} </p>
                <p>Hora: {{ ruta.hora }}</p>
                <p>Localidad: {{ ruta.localidad }}</p>
                <p>Guía: {{ ruta.guia }}</p>
                <p>Asistentes: {{ ruta.asistentes }}</p>
            </div>
            <!-- imagen de la ruta -->
            <div class="col-md-4 foto">
                <img :src="ruta.foto" alt="Foto de la ruta" class="img-fluid mb-3 w-100" />
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
        <div v-else class="alert alert-danger mt-3">
            <p class="alert">Debes iniciar sesión para reservar una ruta</p>
        </div>
    </div>
</template>

<style scoped>
@import '@/assets/styles/main.css';


.foto {
    height: 100%;
    overflow: hidden;
}

.foto img {
    height: 100%;
    width: auto;
    object-fit: cover;
}
</style>