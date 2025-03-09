<script setup>
import { ref, onMounted } from 'vue';
import router from '@/router';
import { useRoute } from 'vue-router';
import 'bootstrap/dist/css/bootstrap.min.css';
import 'bootstrap-notify';

// Props y eventos emitidos
const props = defineProps({
    usuarioAutenticado: {
        type: Object,
        required: true
    }
});

const emits = defineEmits(['sesionIniciada']);

// Variables reactivas
const reservas = ref([]);
const reservasPasadas = ref([]);
const reservasFuturas = ref([]);
const activeTab = ref('futuras');

const showModal = ref(false);
const showEditModal = ref(false);

const selectedReserva = ref(null);
const estrellas = ref(0);
const comentario = ref('');
const numPersonas = ref(0);

// Función para mostrar alertas
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

// Función para abrir el modal de valoración
function openModal(reserva) {
    selectedReserva.value = reserva;
    showModal.value = true;
}

// Función para cerrar el modal de valoración
function closeModal() {
    showModal.value = false;
    selectedReserva.value = null;
    estrellas.value = 0;
    comentario.value = '';
}

// Función para abrir el modal de edición
function openEditModal(reserva) {
    selectedReserva.value = reserva;
    numPersonas.value = reserva.num_personas;
    showEditModal.value = true;
}

// Función para cerrar el modal de edición
function closeEditModal() {
    showEditModal.value = false;
    selectedReserva.value = null;
    numPersonas.value = 0;
}

// Función para enviar la edición de la reserva
function submitEditReserva() {
    if (selectedReserva.value) {
        modificarReserva(selectedReserva.value.reserva_id, numPersonas.value);
        closeEditModal();
    }
}

// Función para enviar la valoración
function submitValoracion() {
    if (selectedReserva.value) {
        valorarRuta(selectedReserva.value.ruta_id, estrellas.value, comentario.value);
        closeModal();
    }
}

// Función para obtener las reservas del usuario
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

// Obtener reservas al montar el componente
onMounted(() => {
    obtenerReservas();
});

// Función para valorar una ruta
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
            showAlert('Valoración creada correctamente', true);
        })
        .catch(error => {
            console.error('Error al crear la valoración:', error);
            showAlert('Error al crear la valoración', false);
        });
}

// Función para modificar una reserva
function modificarReserva(reservaId, numPersonas) {
    const data = {
        num_personas: numPersonas
    };

    fetch(`http://localhost/APIFreetours/api.php/reservas?id=${reservaId}`, {
        method: 'PUT',
        headers: {
            'Content-Type': 'application/json'
        },
        body: JSON.stringify(data)
    })
        .then(response => {
            if (!response.ok) throw new Error(`Error ${response.status}: ${response.statusText}`);
            return response.json();
        })
        .then(data => {
            console.log('Reserva actualizada:', data);
            showAlert('Reserva actualizada correctamente', true);
            obtenerReservas(); // Actualizar la lista de reservas
        })
        .catch(error => {
            console.error('Error al actualizar reserva:', error);
            showAlert('Error al actualizar reserva', false);
        });
}

// Función para cancelar una reserva
function cancelarReserva(reservaId) {
    if (!confirm('¿Estás seguro de que deseas cancelar esta reserva?')) return;

    fetch(`http://localhost/APIFreetours/api.php/reservas?id=${reservaId}`, {
        method: 'DELETE',
    })
        .then(response => {
            if (!response.ok) throw new Error(`Error ${response.status}: ${response.statusText}`);
            return response.json();
        })
        .then(data => {
            console.log('Reserva eliminada:', data);
            showAlert('Reserva cancelada correctamente', true);
            obtenerReservas(); // Actualizar la lista de reservas
        })
        .catch(error => {
            console.error('Error al cancelar reserva:', error);
            showAlert('Error al cancelar reserva', false);
        });
}

</script>

<template>
    <div class="container">
        <h1>Mis Reservas</h1>
        <ul class="nav nav-tabs" role="tablist">
            <li class="nav-item">
                <a class="nav-link" :class="{ active: activeTab === 'futuras' }" @click="activeTab = 'futuras'" role="tab" aria-selected="activeTab === 'futuras'">Próximas Reservas</a>
            </li>
            <li class="nav-item">
                <a class="nav-link" :class="{ active: activeTab === 'pasadas' }" @click="activeTab = 'pasadas'" role="tab" aria-selected="activeTab === 'pasadas'">Reservas Pasadas</a>
            </li>
        </ul>
        <div class="tab-content">
            <div v-if="activeTab === 'futuras'" class="tab-pane active" role="tabpanel">
                <div class="row">
                    <div class="card-deck">
                        <div class="card" v-for="reserva in reservasFuturas" :key="reserva.reserva_id">
                            <img :src="reserva.ruta_foto" class="card-img-top" :alt="`Imagen de la ruta ${reserva.ruta_titulo}`">
                            <div class="card-body">
                                <h5 class="card-title">{{ reserva.ruta_titulo }}</h5>
                                <p class="card-text"><strong>Fecha:</strong> {{ reserva.ruta_fecha }}</p>
                                <p class="card-text"><strong>Hora:</strong> {{ reserva.ruta_hora }}</p>
                                <p class="card-text"><strong>Localidad:</strong> {{ reserva.ruta_localidad }}</p>
                                <p class="card-text"><strong>Descripción:</strong> {{ reserva.ruta_descripcion }}</p>
                                <button @click="openEditModal(reserva)" class="btn btn-secondary" aria-label="Editar reserva de {{ reserva.ruta_titulo }}">Editar Reserva</button>
                                <button @click="cancelarReserva(reserva.reserva_id)" class="btn btn-danger" aria-label="Cancelar reserva de {{ reserva.ruta_titulo }}">Cancelar Reserva</button>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <div v-if="activeTab === 'pasadas'" class="tab-pane active" role="tabpanel">
                <div class="row">
                    <h2>Reservas Pasadas</h2>
                    <div class="card-deck">
                        <div class="card" v-for="reserva in reservasPasadas" :key="reserva.reserva_id">
                            <img :src="reserva.ruta_foto" class="card-img-top" :alt="`Imagen de la ruta ${reserva.ruta_titulo}`">
                            <div class="card-body">
                                <h5 class="card-title">{{ reserva.ruta_titulo }}</h5>
                                <p class="card-text"><strong>Fecha:</strong> {{ reserva.ruta_fecha }}</p>
                                <p class="card-text"><strong>Hora:</strong> {{ reserva.ruta_hora }}</p>
                                <p class="card-text"><strong>Localidad:</strong> {{ reserva.ruta_localidad }}</p>
                                <p class="card-text"><strong>Descripción:</strong> {{ reserva.ruta_descripcion }}</p>
                                <button @click="openModal(reserva)" class="btn btn-primary" aria-label="Añadir valoración a la ruta {{ reserva.ruta_titulo }}">Añadir Valoración</button>
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
                    <button type="button" class="close" @click="closeModal" aria-label="Cerrar">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <div class="modal-body">
                    <div class="form-group">
                        <label for="estrellas">Estrellas</label>
                        <input type="number" id="estrellas" v-model="estrellas" class="form-control" min="1" max="5" aria-label="Número de estrellas">
                    </div>
                    <div class="form-group">
                        <label for="comentario">Comentario</label>
                        <textarea id="comentario" v-model="comentario" class="form-control" aria-label="Comentario"></textarea>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" @click="closeModal" aria-label="Cerrar modal de valoración">Cerrar</button>
                    <button type="button" class="btn btn-primary" @click="submitValoracion" aria-label="Guardar valoración">Guardar Valoración</button>
                </div>
            </div>
        </div>
    </div>
    <div v-if="showEditModal" class="modal" tabindex="-1" role="dialog" style="display: block;">
        <div class="modal-dialog" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">Editar Reserva</h5>
                    <button type="button" class="close" @click="closeEditModal" aria-label="Cerrar">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <div class="modal-body">
                    <div class="form-group">
                        <label for="numPersonas">Número de Asistentes</label>
                        <input type="number" id="numPersonas" v-model="numPersonas" class="form-control" min="1" aria-label="Número de asistentes">
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" @click="closeEditModal" aria-label="Cerrar modal de edición">Cerrar</button>
                    <button type="button" class="btn btn-primary" @click="submitEditReserva" aria-label="Guardar cambios en la reserva">Guardar Cambios</button>
                </div>
            </div>
        </div>
    </div>
</template>

<style scoped>
@import '@/assets/styles/main.css';
.card-deck {
    display: flex;
    flex-wrap: wrap;
    justify-content: space-around;
}
.btn-secondary {
    margin-right: 0.5rem;
}
</style>