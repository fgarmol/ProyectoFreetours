<script setup>
import { ref, computed, onMounted, onUnmounted } from 'vue';

const props = defineProps({
  title: String,
  usuarioAutenticado: {
    type: Object,
    required: true
  }
});

const emits = defineEmits(['sesionIniciada']);

const tours = ref([]);
const paginaActual = ref(1);
const itemsPorPagina = 15;
const opcionOrden = ref('default'); // Por defecto a 'random'
const localidadBusqueda = ref('');
const fechaBusqueda = ref('');

function cargarRutas() {
  let url = 'http://localhost/APIFreetours/api.php/rutas';

  fetch(url, {
    method: 'GET',
  })
    .then(response => response.json())
    .then(data => {
      tours.value = data;
      console.log('Rutas:', data);
    })
    .catch(error => console.error('Error:', error));
}

const toursFiltrados = computed(() => {
  if (!localidadBusqueda.value && !fechaBusqueda.value) {
    return tours.value;
  } else if (localidadBusqueda.value && fechaBusqueda.value) {
    return tours.value.filter(tour => {
      return tour.localidad.toLowerCase().includes(localidadBusqueda.value.toLowerCase()) && tour.fecha === fechaBusqueda.value;
    });
  } else if (fechaBusqueda.value) {
    return tours.value.filter(tour => {
      return tour.fecha === fechaBusqueda.value;
    });
  }

  return tours.value.filter(tour => {
    return tour.localidad.toLowerCase().includes(localidadBusqueda.value.toLowerCase());
  });
});

const toursOrdenados = computed(() => {
  let ordenados = [...toursFiltrados.value];
  if (opcionOrden.value === 'alphabetical') {
    ordenados.sort((a, b) => a.localidad.localeCompare(b.localidad));
  } else if (opcionOrden.value === 'attendees') {
    ordenados.sort((a, b) => b.asistentes - a.asistentes);
  } else if (opcionOrden.value === 'default') {
    ordenados.sort(() => Math.random() - 0.5);
  } else if (opcionOrden.value === 'date') {
    ordenados.sort((a, b) => a.fecha.localeCompare(b.fecha));
  }
  return ordenados;
});

const toursPaginados = computed(() => {
  const inicio = (paginaActual.value - 1) * itemsPorPagina;
  const fin = inicio + itemsPorPagina;
  return toursOrdenados.value.slice(inicio, fin);
});

const totalPaginas = computed(() => {
  return Math.ceil(toursOrdenados.value.length / itemsPorPagina);
});

function paginaSiguiente() {
  if (paginaActual.value < totalPaginas.value) {
    paginaActual.value++;
  }
}

function paginaAnterior() {
  if (paginaActual.value > 1) {
    paginaActual.value--;
  }
}

onMounted(() => {
  cargarRutas();
});

const isPlaying = ref(false);
const progress = ref(0);
const video = ref(null);
const controlsVisible = ref(false);

function togglePlay(event) {
  event.stopPropagation(); // Detener la propagación del evento de clic
  if (video.value.paused) {
    video.value.play();
    isPlaying.value = true;
  } else {
    video.value.pause();
    isPlaying.value = false;
  }
}

function updateProgress() {
  progress.value = (video.value.currentTime / video.value.duration) * 100;
}

function seek(event) {
  const seekTime = (event.target.value / 100) * video.value.duration;
  video.value.currentTime = seekTime;
}

function showControls() {
  controlsVisible.value = true;
}

function hideControls() {
  controlsVisible.value = false;
}
</script>

<template>
  <header>
    <div id="carouselExampleIndicators" class="carousel slide mb-4" data-bs-ride="carousel">
      <div class="carousel-indicators">
        <button type="button" data-bs-target="#carouselExampleIndicators" data-bs-slide-to="0" class="active" aria-current="true" aria-label="Slide 1"></button>
        <button type="button" data-bs-target="#carouselExampleIndicators" data-bs-slide-to="1" aria-label="Slide 2"></button>
        <button type="button" data-bs-target="#carouselExampleIndicators" data-bs-slide-to="2" aria-label="Slide 3"></button>
        <button type="button" data-bs-target="#carouselExampleIndicators" data-bs-slide-to="3" aria-label="Slide 4"></button>
      </div>
      <div class="carousel-inner">
        <div class="carousel-item active">
          <div class="video-container" @mouseover="showControls" @mouseleave="hideControls">
            <video ref="video" class="d-block w-100 carousel-video" @timeupdate="updateProgress" autoplay muted>
              <source src="@/assets/img/video.mp4" type="video/mp4">
              Your browser does not support the video tag.
            </video>
            <div class="video-controls" :class="{ 'hidden': !controlsVisible }">
              <button @click="togglePlay($event)">{{ isPlaying ? 'Pause' : 'Play' }}</button>
              <input type="range" min="0" max="100" v-model="progress" @input="seek">
            </div>
          </div>
        </div>
        <div class="carousel-item">
          <img src="https://picsum.photos/1200/300?random=1" class="d-block w-100" alt="...">
        </div>
        <div class="carousel-item">
          <img src="https://picsum.photos/1200/300?random=2" class="d-block w-100" alt="...">
        </div>
        <div class="carousel-item">
          <img src="https://picsum.photos/1200/300?random=3" class="d-block w-100" alt="...">
        </div>
      </div>
      <button class="carousel-control-prev" type="button" data-bs-target="#carouselExampleIndicators" data-bs-slide="prev">
        <span class="carousel-control-prev-icon" aria-hidden="true"></span>
        <span class="visually-hidden">Previous</span>
      </button>
      <button class="carousel-control-next" type="button" data-bs-target="#carouselExampleIndicators" data-bs-slide="next">
        <span class="carousel-control-next-icon" aria-hidden="true"></span>
        <span class="visually-hidden">Next</span>
      </button>
    </div>
  </header>
  <div class="container">
    <div class="row">
      <!-- Filtros de búsqueda (Sidebar Filters) -->
      <aside class="col-md-3 mb-4">
        <div class="card">
          <div class="card-body-search">
            <div class="mb-3">
              <input type="text" class="form-control" placeholder="Buscar destino" v-model="localidadBusqueda">
            </div>
            <div class="mb-3">
              <label for="date" class="form-label">Fecha</label>
              <input type="date" id="date" class="form-control" v-model="fechaBusqueda">
            </div>
          </div>
        </div>
      </aside>

      <!-- Listado de Tours (Tour List) -->
      <section class="col-md-9">
        <div class="d-flex justify-content-between align-items-center mb-3">
          <div>
            <label for="sort" class="form-label">Ordenar por:</label>
            <select id="sort" class="form-select" v-model="opcionOrden">
              <option value="default">Mejores</option>
              <option value="alphabetical">Alfabético</option>
              <option value="attendees">Cantidad de Asistentes</option>
              <option value="date">Fecha</option>
            </select>
          </div>
          <span class="fw-bold">{{ toursOrdenados.length }} rutas encontradas</span>
        </div>
        <div class="row">
          <div class="col-12 mb-4" v-for="tour in toursPaginados" :key="tour.id">
            <div class="card h-100 flex-md-row shadow-sm">
              <img :src="tour.foto" :alt="tour.titulo" class="card-img-top w-100 w-md-50">
              <div class="card-body d-flex flex-column justify-content-center">
                <h5 class="card-title">{{ tour.titulo }}</h5>
                <h6 class="card-subtitle mb-2 text-muted">{{ tour.localidad }}</h6>
                <div class="d-flex align-items-center mb-2">
                  <!-- <span class="text-warning">⭐⭐⭐⭐⭐</span> -->
                  <span class="ms-2 text-muted">({{ tour.asistentes }} asistentes)</span>
                </div>
                <p class="card-text">{{ tour.descripcion }}</p>
                <p class="card-text"><small class="text-muted">Duración: {{ tour.hora }}</small></p>
                <p class="card-text"><small class="text-muted">Operador: {{ tour.guia_nombre }}</small></p>
                <p class="card-text"><small class="text-muted">Fecha: {{ tour.fecha }}</small></p>
                <router-link :to="'/rutas/' + tour.id" class="btn btn-primary mt-auto">Reservar</router-link>
              </div>
            </div>
          </div>
        </div>
        <div class="d-flex justify-content-center">
          <button @click="paginaAnterior" class="btn btn-secondary me-2"
            :disabled="paginaActual === 1">Anterior</button>
          <span class="align-self-center">Página {{ paginaActual }} de {{ totalPaginas }}</span>
          <button @click="paginaSiguiente" class="btn btn-secondary ms-2"
            :disabled="paginaActual === totalPaginas">Siguiente</button>
        </div>
      </section>
    </div>
  </div>
</template>

<style scoped>
body {
  background-color: white; /* Fondo blanco */
  color: black; /* Texto negro */
}

.header {
  background-color: black; /* Fondo negro */
  color: white; /* Texto blanco */
  padding: 1rem;
}

.carousel-indicators button {
  background-color: black; /* Fondo negro */
}

.carousel-indicators button:hover {
  background-color: white; /* Fondo blanco al pasar el ratón */
}

.carousel-control-prev-icon,
.carousel-control-next-icon {
  filter: invert(1); /* Iconos blancos */
}

.carousel-control-prev-icon:hover,
.carousel-control-next-icon:hover {
  filter: invert(0.5); /* Iconos grises al pasar el ratón */
}

.card {
  background-color: white; /* Fondo blanco */
  border: 1px solid black; /* Borde negro */
  transition: transform 0.3s ease, box-shadow 0.3s ease; /* Transición suave */
}

.card:hover {
  transform: scale(1.05); /* Efecto de zoom al pasar el ratón */
  box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1); /* Sombra suave */
}

.card-title {
  color: black; /* Texto negro */
}

.card-subtitle {
  color: gray; /* Texto gris */
}

.btn-primary, .btn-secondary {
  background-color: black; /* Fondo negro */
  color: white; /* Texto blanco */
  border: none; /* Sin borde */
  transition: background-color 0.3s ease, color 0.3s ease; /* Transición suave */
}

.btn-primary:hover, .btn-secondary:hover {
  background-color: wheat; /* Fondo blanco al pasar el ratón */
  color: black; /* Texto negro al pasar el ratón */
}

.card-img-top {
  height: 200px;
  object-fit: cover;
}

.carousel-video, .carousel-item img {
  width: 100%;
  height: 300px; /* Ajusta esta altura para que coincida con la altura de las imágenes */
  object-fit: cover;
}

.video-container {
  position: relative;
  display: flex;
  align-items: center;
  justify-content: center;
}

.video-controls {
  position: absolute;
  top: 0;
  left: 0;
  width: 100%;
  display: flex;
  justify-content: space-between;
  background: rgba(0, 0, 0, 0.5);
  color: white;
  padding: 5px;
  z-index: 10; /* Asegura que los controles estén por encima de otros elementos */
  transition: opacity 0.3s;
}

.video-controls.hidden {
  opacity: 0;
  pointer-events: none;
}

.video-controls button {
  background: none;
  border: none;
  color: white;
  cursor: pointer;
}

.video-controls input[type="range"] {
  flex-grow: 1;
  margin: 0 10px;
}

.container {
  padding-bottom: 5rem;
}

.card-body-search {
  padding: 1rem;
}

@media (min-width: 768px) {
  .card-img-top {
    height: auto;
    width: 50%;
    object-fit: cover;
  }

  .card.h-100 {
    display: flex;
    flex-direction: row;
  }

  .card-body {
    display: flex;
    flex-direction: column;
    justify-content: center;
    width: 50%; /* Asegura que el cuerpo de la tarjeta tenga el mismo ancho */
  }

  .card-body-search {
    padding: 1rem;
  }
}
</style>