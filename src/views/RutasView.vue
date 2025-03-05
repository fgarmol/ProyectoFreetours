<script setup>
import { ref, onMounted } from 'vue';
import { useRoute } from 'vue-router';
import 'bootstrap/dist/css/bootstrap.min.css';
import 'bootstrap-notify';

const props = defineProps({
    usuarioAutenticado: {
        type: Object,
        required: true
    }
});

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

</script>

<template>
    <div v-if="ruta" class="container">
        <h1>{{ ruta.titulo }}</h1>
        <p>{{ ruta.descripcion }}</p>
        <p>Fecha: {{ formatDate(ruta.fecha) }} </p>
        <p>Hora: {{ ruta.hora }}</p>
        <p>Localidad: {{ ruta.localidad }}</p>
        <p>Guía: {{ ruta.guia }}</p>
        <p>Asistentes: {{ ruta.asistentes }}</p>

        <div v-if="props.usuarioAutenticado.autenticado">
            <form @submit.prevent="reservar" class="form">
                <div class="form-group mt-3">
                    <label for="email">Email:&nbsp</label>
                    <input type="email" v-model="props.usuarioAutenticado.usuario.email" class="form-control" disabled />
                </div>
                <div class="form-group mt-3">
                    <label for="asistentes">Cantidad de asistentes:&nbsp</label>
                    <input type="number" id="asistentes" v-model="asistentes" class="form-control" min="1" />
                </div>
                <button type="submit" class="btn btn-primary">Reservar</button>
            </form>
        </div>
        <div v-else class="alert alert-danger">
            <p class="alert">Debes estar logueado para reservar una ruta</p>
        </div>

        <div id="alert" class="alert"></div>
    </div>
</template>

<style scoped>
.container {
    padding-bottom: 5rem;
}
</style>
