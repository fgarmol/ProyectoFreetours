<script setup>
import { ref, onMounted } from 'vue';

const props = defineProps({
    usuarioAutenticado: {
        type: Object,
        required: true
    }
});

const emits = defineEmits(['sesionIniciada']);

const rutasAsignadas = ref([]);
const asistentes = ref([]);
const showModal = ref(false);
const selectedRuta = ref(null);

function showAlert(message, isSuccess = false) {
    const alert = document.getElementById('alert');
    alert.textContent = message;
    alert.style.display = 'block';
    alert.className = isSuccess ? 'alert success' : 'alert';
}

function obtenerRutasAsignadas() {
    const guiaId = props.usuarioAutenticado.usuario.id;
    fetch(`http://localhost/APIFreetours/api.php/asignaciones?guia_id=${guiaId}`)
        .then(response => response.json())
        .then(data => {
            rutasAsignadas.value = data;
        })
        .catch(error => showAlert(`Error al obtener rutas asignadas: ${error.message}`));
}

function verAsistentes(ruta) {
    selectedRuta.value = ruta;
    asistentes.value = ruta.reservas;
    showModal.value = true;
}

function closeModal() {
    showModal.value = false;
    selectedRuta.value = null;
    asistentes.value = [];
}

onMounted(() => {
    obtenerRutasAsignadas();
});
</script>

<template>
    <div class="container">
        <h1>Rutas Asignadas</h1>
        <div id="alert" class="alert"></div>
        <div v-for="ruta in rutasAsignadas" :key="ruta.ruta_id" class="card mb-3">
            <div class="card-body">
                <h5 class="card-title">{{ ruta.ruta_titulo }}</h5>
                <p class="card-text"><strong>Localidad:</strong> {{ ruta.ruta_localidad }}</p>
                <p class="card-text"><strong>Fecha:</strong> {{ ruta.ruta_fecha }}</p>
                <p class="card-text"><strong>Hora:</strong> {{ ruta.ruta_hora }}</p>
                <button @click="verAsistentes(ruta)" class="btn btn-primary">Ver Asistentes</button>
            </div>
        </div>
    </div>

    <div v-if="showModal" class="modal" tabindex="-1" role="dialog" style="display: block;">
        <div class="modal-dialog" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">Listado de Asistentes</h5>
                    <button type="button" class="close" @click="closeModal" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <div class="modal-body">
                    <ul class="list-group">
                        <li v-for="asistente in asistentes" :key="asistente.reserva_id" class="list-group-item">
                            {{ asistente.cliente.email }} - {{ asistente.num_personas }} asistentes
                        </li>
                    </ul>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" @click="closeModal">Cerrar</button>
                </div>
            </div>
        </div>
    </div>
</template>

<style scoped>
.container {
    padding-bottom: 5rem;
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