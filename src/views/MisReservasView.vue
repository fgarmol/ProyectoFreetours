<script setup>
import { ref, onMounted } from 'vue';
import router from '@/router';
import { useRoute } from 'vue-router';

import L from 'leaflet';
import 'leaflet/dist/leaflet.css';

const props = defineProps({
    usuarioAutenticado: {
        type: Object,
        required: true
    }
});

const reservas = ref([]);
const reservasPasadas = ref([]);
const reservasFuturas = ref([]);


function obtenerReservas() {
    const userEmail = props.usuarioAutenticado.usuario.email;
    console.log('Email:', userEmail);
    fetch(`http://localhost/APIFreetours/api.php/reservas?email=${userEmail}`, {
        method: 'GET',
    })
        .then(response => response.json())
        .then(data => {
            console.log('Reservas:', data);
            reservas.value = data;
            reservasFuturas.value = reservas.value.filter(reserva => {
                const fechaReserva = new Date(reserva.ruta_fecha);
                const fechaActual = new Date();
                return fechaReserva >= fechaActual;
            });

            reservasPasadas.value = reservas.value.filter(reserva => {
                const fechaReserva = new Date(reserva.ruta_fecha);
                const fechaActual = new Date();
                return fechaReserva < fechaActual;
            });
        })
        .catch(error => console.error('Error:', error));
}

onMounted(() => {
    obtenerReservas();
});
</script>

<template>
    <div class="container">
        <h1>Mis Reservas</h1>
        <div class="row">
            <div class="col">
                <h2>Reservas Futuras</h2>
                <div class="card-deck">
                    <div class="card" v-for="reserva in reservasFuturas" :key="reserva.reserva_id">
                        <img :src="reserva.ruta_foto" class="card-img-top" alt="Imagen de la ruta">
                        <div class="card-body">
                            <h5 class="card-title">{{ reserva.ruta_titulo }}</h5>
                            <p class="card-text"><strong>Fecha:</strong> {{ reserva.ruta_fecha }}</p>
                            <p class="card-text"><strong>Hora:</strong> {{ reserva.ruta_hora }}</p>
                            <p class="card-text"><strong>Localidad:</strong> {{ reserva.ruta_localidad }}</p>
                            <p class="card-text"><strong>Descripción:</strong> {{ reserva.ruta_descripcion }}</p>
                        </div>
                    </div>
                </div>
            </div>
            <div class="col">
                <h2>Reservas Pasadas</h2>
                <div class="card-deck">
                    <div class="card" v-for="reserva in reservasPasadas" :key="reserva.reserva_id">
                        <img :src="reserva.ruta_foto" class="card-img-top" alt="Imagen de la ruta">
                        <div class="card-body">
                            <h5 class="card-title">{{ reserva.ruta_titulo }}</h5>
                            <p class="card-text"><strong>Fecha:</strong> {{ reserva.ruta_fecha }}</p>
                            <p class="card-text"><strong>Hora:</strong> {{ reserva.ruta_hora }}</p>
                            <p class="card-text"><strong>Localidad:</strong> {{ reserva.ruta_localidad }}</p>
                            <p class="card-text"><strong>Descripción:</strong> {{ reserva.ruta_descripcion }}</p>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</template>

<style scoped>
.card-deck {
    display: flex;
    flex-wrap: wrap;
    justify-content: space-around;
}

.card {
    margin: 10px;
    width: 18rem;
}
</style>