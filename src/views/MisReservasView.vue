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

const reservas = ref([]);
const reservasPasadas = ref([]);
const reservasFuturas = ref([]);


function obtenerReservas() {
    fetch(`http://localhost/APIFreetours/api.php/reservas?email=${props.usuarioAutenticado.usuario.email}`, {
        method: 'GET',
    })
        .then(response => response.json())
        .then(data => {
            console.log('Reservas:', data);
            reservas.value = data;
            reservasPasadas.value = data.filter(reserva => new Date(reserva.fecha) < new Date());
            reservasFuturas.value = data.filter(reserva => new Date(reserva.fecha) >= new Date());
        })
        .catch(error => console.error('Error:', error));
}

onMounted(() => {
    obtenerReservas();
});


/* 2. Obtener las reservas de un usuario específico por su email (GET)
const userEmail = 'usuario@ejemplo.com'; // Email del usuario
fetch(`http://localhost/api.php/reservas?email=${userEmail}`, {
    method: 'GET',
})
.then(response => response.json())
.then(data => console.log('Reservas del usuario:', data))
.catch(error => console.error('Error:', error)); */


</script>



<template>

    <div class="container">
        <h1>Mis Reservas</h1>
        <div class="row">
            <div class="col">
                <h2>Reservas Futuras</h2>
                <table class="table">
                    <thead>
                        <tr>
                            <th scope="col">Fecha</th>
                            <th scope="col">Hora</th>
                            <th scope="col">Título</th>
                            <th scope="col">Localidad</th>
                            <th scope="col">Guía</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr v-for="reserva in reservasFuturas" :key="reserva.id">
                            <td>{{ reserva.fecha }}</td>
                            <td>{{ reserva.hora }}</td>
                            <td>{{ reserva.titulo }}</td>
                            <td>{{ reserva.localidad }}</td>
                            <td>{{ reserva.guia }}</td>
                        </tr>
                    </tbody>
                </table>
            </div>
            <div class="col">
                <h2>Reservas Pasadas</h2>
                <table class="table">
                    <thead>
                        <tr>
                            <th scope="col">Fecha</th>
                            <th scope="col">Hora</th>
                            <th scope="col">Título</th>
                            <th scope="col">Localidad</th>
                            <th scope="col">Guía</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr v-for="reserva in reservasPasadas" :key="reserva.id">
                            <td>{{ reserva.fecha }}</td>
                            <td>{{ reserva.hora }}</td>
                            <td>{{ reserva.titulo }}</td>
                            <td>{{ reserva.localidad }}</td>
                            <td>{{ reserva.guia }}</td>
                        </tr>
                    </tbody>
                </table>
            </div>
        </div>
    </div>




</template>


<style scooped></style>