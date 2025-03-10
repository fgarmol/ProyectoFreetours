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
    const alert = document.getElementById('alert');
    alert.textContent = message;
    alert.style.display = 'block';
    alert.className = isSuccess ? 'alert success' : 'alert';
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
        <div id="alert" class="alert"></div>
        <h1 class="m-3 mt-1">Crear Ruta</h1>
        <form @submit.prevent="crearRuta" class="form m-3">
            <div class="form-group">
                <label for="titulo">Título</label>
                <input type="text" class="form-control" id="titulo" v-model="newRuta.titulo">
            </div>
            <div class="form-group">
                <label for="localidad">Localidad</label>
                <input type="text" class="form-control" id="localidad" v-model="newRuta.localidad">
            </div>
            <div class="form-group">
                <label for="descripcion">Descripción</label>
                <textarea class="form-control" id="descripcion" rows="3" v-model="newRuta.descripcion"></textarea>
            </div>
            <div class="form-group">
                <label for="foto">Foto</label>
                <input type="text" class="form-control" id="foto" placeholder="URL" v-model="newRuta.foto">
            </div>
            <div class="form-group">
                <label for="fecha">Fecha</label>
                <input type="date" class="form-control" id="fecha" v-model="newRuta.fecha"
                    @change="cargarGuia(newRuta.fecha)">
            </div>
            <div class="form-group">
                <label for="hora">Hora</label>
                <input type="time" class="form-control" id="hora" v-model="newRuta.hora">
            </div>
            <div class="form-group">
                <label for="latitud">Latitud</label>
                <input type="text" class="form-control" id="latitud" v-model="newRuta.latitud">
            </div>
            <div class="form-group">
                <label for="longitud">Longitud</label>
                <input type="text" class="form-control" id="longitud" v-model="newRuta.longitud">
            </div>
            <div class="form-group">
                <label for="guia">Guía</label>
                <select class="form-control" id="guia" v-model="newRuta.guia_id">
                    <option v-for="guia in guias" :key="guia.id" :value="guia.id">{{ guia.nombre }}: {{ guia.id }}
                    </option>
                </select>
            </div>
            <button type="submit" class="btn btn-primary">Crear</button>


            <div class="form-group mt-3">
                <input v-model="address" @keyup.enter="searchLocation" placeholder="Buscar dirección"
                    class="input " />
                <button @click="searchLocation" class="btn btn-secondary">Buscar</button>
                <div id="map"></div>
            </div>
        </form>

    </div>
</template>

<style scoped>
.container {
    padding-bottom: 5rem;
}

#map {
    height: 300px;
    margin-top: 1rem;

}

.footer {
    z-index: 5000;
}
</style>