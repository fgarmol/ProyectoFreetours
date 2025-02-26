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
            // Ordenar las rutas por fecha
            rutasAsignadas.value = data.sort((a, b) => new Date(a.ruta_fecha) - new Date(b.ruta_fecha));
        })
        .catch(error => showAlert(`Error al obtener rutas asignadas: ${error.message}`));
}

function verAsistentes(ruta) {
    selectedRuta.value = ruta;
    asistentes.value = ruta.reservas;
}

function actualizarAsistentes(asistente) {
    fetch(`http://localhost/APIFreetours/api.php/reservas?id=${asistente.reserva_id}`, {
        method: 'PUT',
        headers: {
            'Content-Type': 'application/json'
        },
        body: JSON.stringify({ num_personas: asistente.num_personas })
    })
    .then(response => response.json())
    .then(data => {
        showAlert('Número de asistentes actualizado correctamente', true);
    })
    .catch(error => showAlert(`Error al actualizar asistentes: ${error.message}`));
}

function calcularTotalAsistentes(ruta) {
    return ruta.reservas.reduce((total, reserva) => total + reserva.num_personas, 0);
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
                <p class="card-text"><strong>Total de Asistentes:</strong> {{ calcularTotalAsistentes(ruta) }}</p>
                <button @click="verAsistentes(ruta)" class="btn btn-primary">Ver Asistentes</button>
                <div v-if="selectedRuta && selectedRuta.ruta_id === ruta.ruta_id" class="accordion mt-3">
                    <div v-for="asistente in asistentes" :key="asistente.reserva_id" class="accordion-item">
                        <h2 class="accordion-header">
                            <button class="accordion-button" type="button" data-bs-toggle="collapse" :data-bs-target="'#collapse' + asistente.reserva_id">
                                {{ asistente.cliente.email }} - {{ asistente.num_personas }} asistentes
                            </button>
                        </h2>
                        <div :id="'collapse' + asistente.reserva_id" class="accordion-collapse collapse">
                            <div class="accordion-body">
                                <form @submit.prevent="actualizarAsistentes(asistente)">
                                    <div class="mb-3">
                                        <label for="numPersonas" class="form-label">Número de asistentes</label>
                                        <input type="number" v-model="asistente.num_personas" class="form-control" id="numPersonas" required>
                                    </div>
                                    <button type="submit" class="btn btn-primary">Actualizar</button>
                                </form>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</template>

<style scoped>
.container {
    padding-bottom: 5rem;
}

.accordion-button {
    cursor: pointer;
}
</style>