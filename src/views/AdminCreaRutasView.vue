<script setup>
import { ref, onMounted } from 'vue';
import router from '@/router';
import L from 'leaflet';
import 'leaflet/dist/leaflet.css';

const users = ref([]);
const guias = ref([]);
const address = ref('');
let map;
let marker;

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

function crearRuta() {
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
    map = L.map('map').setView([40.4168, -3.7038], 13); // Madrid por defecto

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
                </div>
                <div class="form-group col-md-6">
                    <label for="localidad">Localidad</label>
                    <input type="text" class="form-control" id="localidad" v-model="newRuta.localidad">
                </div>
            </div>
            <div class="form-group">
                <label for="descripcion">Descripción</label>
                <textarea class="form-control" id="descripcion" rows="3" v-model="newRuta.descripcion"></textarea>
            </div>
            <div class="form-group">
                <label for="foto">Foto</label>
                <input type="text" class="form-control" id="foto" placeholder="URL" v-model="newRuta.foto">
            </div>
            <div class="row">
                <div class="form-group col-md-6">
                    <label for="fecha">Fecha</label>
                    <input type="date" class="form-control" id="fecha" v-model="newRuta.fecha"
                        @change="cargarGuia(newRuta.fecha)">
                </div>
                <div class="form-group col-md-6">
                    <label for="hora">Hora</label>
                    <input type="time" class="form-control" id="hora" v-model="newRuta.hora">
                </div>
            </div>
            <div class="row">
                <div class="form-group col-md-6">
                    <label for="latitud">Latitud</label>
                    <input type="text" class="form-control" id="latitud" v-model="newRuta.latitud">
                </div>
                <div class="form-group col-md-6">
                    <label for="longitud">Longitud</label>
                    <input type="text" class="form-control" id="longitud" v-model="newRuta.longitud">
                </div>
            </div>
            <div class="form-group">
                <label for="guia">Guía</label>
                <select class="form-control" id="guia" v-model="newRuta.guia_id">
                    <option v-for="guia in guias" :key="guia.id" :value="guia.id">{{ guia.nombre }}: {{ guia.id }}
                    </option>
                </select>
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
@import url('https://fonts.googleapis.com/css2?family=Roboto:wght@400;700&display=swap');

.container {
    padding-bottom: 5rem;
    background-color: white;
    /* Fondo blanco */
    color: black;
    /* Texto negro */
    font-family: 'Roboto', sans-serif;
    /* Fuente minimalista */
}

h1 {
    font-size: 2rem;
    font-weight: bold;
    color: black;
    text-align: center;
    margin-bottom: 1rem;
}

.form-group label {
    font-weight: bold;
    color: black;
}

.form-control {
    background-color: white;
    color: black;
    border: 1px solid black;
    transition: border-color 0.3s ease, box-shadow 0.3s ease;
}

.form-control:focus {
    border-color: black;
    box-shadow: 0 0 5px rgba(0, 0, 0, 0.2);
}

.btn-secondary {
    margin-top: 1rem;
    background-color: black;
    color: white;
    border: none;
    transition: background-color 0.3s ease, color 0.3s ease, transform 0.3s ease;
}

.btn-secondary:hover {
    background-color: white;
    color: black;
    transform: scale(1.05);
}

.btn-secondary:active {
    background-color: black;
    color: white;
    box-shadow: inset 1px 1px 30px white;
}

#map {
    height: 300px;
    margin-top: 1rem;
    border: 1px solid black;
}

.footer {
    z-index: 5000;
}
</style>