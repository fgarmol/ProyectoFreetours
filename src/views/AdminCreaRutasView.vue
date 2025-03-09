<script setup>
import { ref, onMounted, defineProps } from 'vue';
import router from '@/router';
import L from 'leaflet';
import 'leaflet/dist/leaflet.css';

const users = ref([]);
const guias = ref([]);
const address = ref('');
let map;
let marker;

const props = defineProps({
  usuarioAutenticado: Object
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

const newRuta = ref({
    titulo: '',
    localidad: '',
    descripcion: '',
    foto: '',
    fecha: '',
    hora: '',
    latitud: '',
    longitud: '',
    guia_id: ''
});

const errors = ref({
    titulo: '',
    localidad: '',
    descripcion: '',
    foto: '',
    fecha: '',
    hora: '',
    latitud: '',
    longitud: '',
    guia_id: ''
});

function clearForm() {
    newRuta.value = {
        titulo: '',
        localidad: '',
        descripcion: '',
        foto: '',
        fecha: '',
        hora: '',
        latitud: '',
        longitud: '',
        guia_id: ''
    };
    errors.value = {
        titulo: '',
        localidad: '',
        descripcion: '',
        foto: '',
        fecha: '',
        hora: '',
        latitud: '',
        longitud: '',
        guia_id: ''
    };
}

function cargarGuia() {
    fetch(`http://localhost/APIFreetours/api.php/asignaciones?fecha=${newRuta.value.fecha}`)
        .then(response => {
            if (!response.ok) {
                throw new Error(`Error ${response.status}: ${response.statusText}`);
            }
            return response.json();
        })
        .then(data => {
            guias.value = data;
        })
        .catch(error => showAlert(`Error al cargar guías: ${error.message}`));
}

function validarFormulario() {
    let isValid = true;
    const today = new Date().toISOString().split('T')[0]; // Obtener la fecha de hoy en formato YYYY-MM-DD
    const urlPattern = new RegExp('^(https?:\\/\\/)?'+ // protocolo
        '((([a-z\\d]([a-z\\d-]*[a-z\\d])*)\\.?)+[a-z]{2,}|'+ // dominio
        '((\\d{1,3}\\.){3}\\d{1,3}))'+ // IP (v4) dirección
        '(\\:\\d+)?(\\/[-a-z\\d%_.~+]*)*'+ // puerto y ruta
        '(\\?[;&a-z\\d%_.~+=-]*)?'+ // cadena de consulta
        '(\\#[-a-z\\d_]*)?$','i'); // fragmento de anclaje

    if (!newRuta.value.titulo) {
        errors.value.titulo = 'El título es obligatorio';
        isValid = false;
    } else {
        errors.value.titulo = '';
    }
    if (!newRuta.value.localidad) {
        errors.value.localidad = 'La localidad es obligatoria';
        isValid = false;
    } else {
        errors.value.localidad = '';
    }
    if (!newRuta.value.descripcion) {
        errors.value.descripcion = 'La descripción es obligatoria';
        isValid = false;
    } else {
        errors.value.descripcion = '';
    }
    if (!newRuta.value.foto) {
        errors.value.foto = 'La foto es obligatoria';
        isValid = false;
    } else if (!urlPattern.test(newRuta.value.foto)) {
        errors.value.foto = 'La foto debe ser una URL válida';
        isValid = false;
    } else {
        errors.value.foto = '';
    }
    if (!newRuta.value.fecha) {
        errors.value.fecha = 'La fecha es obligatoria';
        isValid = false;
    } else if (newRuta.value.fecha < today) {
        errors.value.fecha = 'La fecha no puede ser anterior a hoy';
        isValid = false;
    } else {
        errors.value.fecha = '';
    }
    if (!newRuta.value.hora) {
        errors.value.hora = 'La hora es obligatoria';
        isValid = false;
    } else {
        errors.value.hora = '';
    }
    if (!newRuta.value.latitud) {
        errors.value.latitud = 'La latitud es obligatoria';
        isValid = false;
    } else {
        errors.value.latitud = '';
    }
    if (!newRuta.value.longitud) {
        errors.value.longitud = 'La longitud es obligatoria';
        isValid = false;
    } else {
        errors.value.longitud = '';
    }
    if (!newRuta.value.guia_id) {
        errors.value.guia_id = 'El guía es obligatorio';
        isValid = false;
    } else {
        errors.value.guia_id = '';
    }
    return isValid;
}

function crearRuta() {
    if (!validarFormulario()) {
        showAlert('Por favor, corrige los errores en el formulario', false);
        return;
    }
    const data = {
        titulo: newRuta.value.titulo,
        localidad: newRuta.value.localidad,
        descripcion: newRuta.value.descripcion,
        foto: newRuta.value.foto,
        fecha: newRuta.value.fecha,
        hora: newRuta.value.hora,
        latitud: newRuta.value.latitud,
        longitud: newRuta.value.longitud,
        guia_id: newRuta.value.guia_id
    };
    fetch("http://localhost/APIFreetours/api.php/rutas", {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json'
        },
        body: JSON.stringify(data)
    })
        .then(response => {
            if (!response.ok) {
                throw new Error(`Error ${response.status}: ${response.statusText}`);
            }
            return response.json();
        })
        .then(data => {
            showAlert('Ruta creada correctamente', true);
            clearForm();
            setTimeout(() => {
                router.push('/admin/rutas');
            }, 1000);
        })
        .catch(error => showAlert(`Error al crear ruta: ${error.message}`));
}

onMounted(() => {
    if (props.usuarioAutenticado.autenticado && props.usuarioAutenticado.usuario.rol === 'admin') {
        map = L.map('map').setView([40.4168, -3.7038], 13); 

        L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
            attribution: '&copy; OpenStreetMap contributors',
            maxZoom: 19,
        }).addTo(map);

        map.on('click', function (e) {
            const { lat, lng } = e.latlng;
            newRuta.value.latitud = lat;
            newRuta.value.longitud = lng;
            if (marker) marker.remove();
            marker = L.marker([lat, lng]).addTo(map)
                .bindPopup(`Lat: ${lat}, Lng: ${lng}`)
                .openPopup();
        });
    } else {
        router.push('/');
    }
});

const searchLocation = async () => {
    if (!address.value) return;
    const response = await fetch(
        `https://nominatim.openstreetmap.org/search?format=json&q=${encodeURIComponent(address.value)}`
    );
    const data = await response.json();
    if (data.length > 0) {
        const { lat, lon } = data[0];
        if (marker) marker.remove();
        marker = L.marker([lat, lon]).addTo(map)
            .bindPopup(address.value)
            .openPopup();
        map.setView([lat, lon], 13);
        newRuta.value.latitud = lat;
        newRuta.value.longitud = lon;
    } else {
        showAlert('Dirección no encontrada', false);
    }
};
</script>

<template>
    <div class="container">
        <div id="alert" class="alert" style="display: none;"></div>
        <h1 class="m-3 mt-1">Crear Ruta</h1>
        <form @submit.prevent="crearRuta" class="form m-3">
            <div class="row">
                <div class="form-group col-md-6">
                    <label for="titulo">Título</label>
                    <input type="text" class="form-control" id="titulo" v-model="newRuta.titulo">
                    <span class="text-danger">{{ errors.titulo }}</span>
                </div>
                <div class="form-group col-md-6">
                    <label for="localidad">Localidad</label>
                    <input type="text" class="form-control" id="localidad" v-model="newRuta.localidad">
                    <span class="text-danger">{{ errors.localidad }}</span>
                </div>
            </div>
            <div class="form-group">
                <label for="descripcion">Descripción</label>
                <textarea class="form-control" id="descripcion" rows="3" v-model="newRuta.descripcion"></textarea>
                <span class="text-danger">{{ errors.descripcion }}</span>
            </div>
            <div class="form-group">
                <label for="foto">Foto</label>
                <input type="text" class="form-control" id="foto" placeholder="URL" v-model="newRuta.foto">
                <span class="text-danger">{{ errors.foto }}</span>
            </div>
            <div class="row">
                <div class="form-group col-md-6">
                    <label for="fecha">Fecha</label>
                    <input type="date" class="form-control" id="fecha" v-model="newRuta.fecha"
                        @change="cargarGuia(newRuta.fecha)">
                    <span class="text-danger">{{ errors.fecha }}</span>
                </div>
                <div class="form-group col-md-6">
                    <label for="hora">Hora</label>
                    <input type="time" class="form-control" id="hora" v-model="newRuta.hora">
                    <span class="text-danger">{{ errors.hora }}</span>
                </div>
            </div>
            <div class="row">
                <div class="form-group col-md-6">
                    <label for="latitud">Latitud</label>
                    <input type="text" class="form-control" id="latitud" v-model="newRuta.latitud">
                    <span class="text-danger">{{ errors.latitud }}</span>
                </div>
                <div class="form-group col-md-6">
                    <label for="longitud">Longitud</label>
                    <input type="text" class="form-control" id="longitud" v-model="newRuta.longitud">
                    <span class="text-danger">{{ errors.longitud }}</span>
                </div>
            </div>
            <div class="form-group">
                <label for="guia">Guía</label>
                <select class="form-control" id="guia" v-model="newRuta.guia_id">
                    <option v-for="guia in guias" :key="guia.id" :value="guia.id">{{ guia.nombre }}: {{ guia.id }}
                    </option>
                </select>
                <span class="text-danger">{{ errors.guia_id }}</span>
            </div>
            <button type="submit" class="btn btn-secondary">Crear</button>

            <div class="form-group mt-3">
                <input v-model="address" @keyup.enter="searchLocation" placeholder="Buscar dirección"
                    class="form-control" />
                <button @click="searchLocation" class="btn btn-secondary mt-2">Buscar</button>
                <div id="map" class="mt-3"></div>
            </div>
        </form>
    </div>
</template>

<style scoped>

@import '@/assets/styles/main.css';

#map {
    height: 300px;
    margin-top: 1rem;
    border: 1px solid black;
}


</style>