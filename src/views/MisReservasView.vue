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
const activeTab = ref('futuras');

const showModal = ref(false);
const selectedReserva = ref(null);
const estrellas = ref(0);
const comentario = ref('');

function showAlert(){
    
}


function openModal(reserva) {
    selectedReserva.value = reserva;
    showModal.value = true;
}

function closeModal() {
    showModal.value = false;
    selectedReserva.value = null;
    estrellas.value = 0;
    comentario.value = '';
}

function submitValoracion() {
    if (selectedReserva.value) {
        valorarRuta(selectedReserva.value.ruta_id, estrellas.value, comentario.value);
        closeModal();
    }
}

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


function valorarRuta(rutaId, estrellas, comentario) {
    const nuevaValoracion = {
        user_id: props.usuarioAutenticado.usuario.id,
        ruta_id: rutaId,
        estrellas: estrellas,
        comentario: comentario
    };

    fetch('http://localhost/APIFreetours/api.php/valoraciones', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json'
        },
        body: JSON.stringify(nuevaValoracion)
    })
        .then(response => {
            if (!response.ok) {
                throw new Error('Error en la solicitud: ' + response.status);
            }
            return response.json();
        })
        .then(data => {
            console.log('Valoración creada:', data);
            // Manejar la respuesta según sea necesario
        })
        .catch(error => {
            console.error('Error al crear la valoración:', error);
        });
}

</script>

<template>
    <div class="container">
        <h1>Mis Reservas</h1>
        <ul class="nav nav-tabs">
            <li class="nav-item">
                <a class="nav-link" :class="{ active: activeTab === 'futuras' }" @click="activeTab = 'futuras'">Próximas
                    Reservas</a>
            </li>
            <li class="nav-item">
                <a class="nav-link" :class="{ active: activeTab === 'pasadas' }" @click="activeTab = 'pasadas'">Reservas
                    Pasadas</a>
            </li>
        </ul>
        <div class="tab-content">
            <div v-if="activeTab === 'futuras'" class="tab-pane active">
                <div class="row">
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
            </div>
            <div v-if="activeTab === 'pasadas'" class="tab-pane active">
                <div class="row">
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
                                <button @click="openModal(reserva)" class="btn btn-primary">Añadir Valoración</button>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <div v-if="showModal" class="modal" tabindex="-1" role="dialog" style="display: block;">
        <div class="modal-dialog" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">Añadir Valoración</h5>
                    <button type="button" class="close" @click="closeModal" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <div class="modal-body">
                    <div class="form-group">
                        <label for="estrellas">Estrellas</label>
                        <input type="number" id="estrellas" v-model="estrellas" class="form-control" min="1" max="5">
                    </div>
                    <div class="form-group">
                        <label for="comentario">Comentario</label>
                        <textarea id="comentario" v-model="comentario" class="form-control"></textarea>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" @click="closeModal">Cerrar</button>
                    <button type="button" class="btn btn-primary" @click="submitValoracion">Guardar Valoración</button>
                </div>
            </div>
        </div>
    </div>
</template>

<style scoped>
.container {
    padding-bottom: 5rem;
}

.card-deck {
    display: flex;
    flex-wrap: wrap;
    justify-content: space-around;
}

.card {
    margin: 10px;
    width: 18rem;
}

.nav-tabs {
    margin-bottom: 1rem;
}

.nav-link {
    cursor: pointer;
}

.modal {
    background: rgba(0, 0, 0, 0.5);
    position: fixed;
    top: 0;
    left: 0;
    width: 100%;
    height: 100%;
    display: flex;
    align-items: center;
    justify-content: center;
}
</style>