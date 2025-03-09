<script setup>
import { ref, computed, onMounted, onUnmounted } from 'vue';

// Props y eventos emitidos
const props = defineProps({
  title: String,
  usuarioAutenticado: {
    type: Object,
    required: true
  }
});

const emits = defineEmits(['sesionIniciada']);

// Variables reactivas
const tours = ref([]);
const paginaActual = ref(1);
const itemsPorPagina = 15;
const opcionOrden = ref('default'); // Orden por defecto
const localidadBusqueda = ref('');
const fechaBusqueda = ref('');

// Función para cargar rutas desde la API
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

// Función para obtener la fecha actual en formato YYYY-MM-DD
function obtenerFechaActual() {
  const hoy = new Date();
  const dia = String(hoy.getDate()).padStart(2, '0');
  const mes = String(hoy.getMonth() + 1).padStart(2, '0');
  const año = hoy.getFullYear();
  return `${año}-${mes}-${dia}`;
}

// Computed para filtrar tours según la fecha y búsqueda
const toursFiltrados = computed(() => {
  const fechaActual = obtenerFechaActual();
  let filtrados = tours.value.filter(tour => tour.fecha >= fechaActual);

  if (!localidadBusqueda.value && !fechaBusqueda.value) {
    return filtrados;
  } else if (localidadBusqueda.value && fechaBusqueda.value) {
    return filtrados.filter(tour => {
      return tour.localidad.toLowerCase().includes(localidadBusqueda.value.toLowerCase()) && tour.fecha === fechaBusqueda.value;
    });
  } else if (fechaBusqueda.value) {
    return filtrados.filter(tour => {
      return tour.fecha === fechaBusqueda.value;
    });
  }

  return filtrados.filter(tour => {
    return tour.localidad.toLowerCase().includes(localidadBusqueda.value.toLowerCase());
  });
});

// Computed para ordenar tours según la opción seleccionada
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

// Computed para paginar tours
const toursPaginados = computed(() => {
  const inicio = (paginaActual.value - 1) * itemsPorPagina;
  const fin = inicio + itemsPorPagina;
  return toursOrdenados.value.slice(inicio, fin);
});

// Computed para calcular el total de páginas
const totalPaginas = computed(() => {
  return Math.ceil(toursOrdenados.value.length / itemsPorPagina);
});

// Funciones para cambiar de página
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

// Cargar rutas al montar el componente
onMounted(() => {
  cargarRutas();
});

// Variables y funciones para controlar el video
const isPlaying = ref(false);
const progress = ref(0);
const video = ref(null);
const controlsVisible = ref(false);

function togglePlay(event) {
  event.stopPropagation();
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
            <video ref="video" class="d-block w-100 carousel-video" @timeupdate="updateProgress" autoplay muted aria-label="Video de presentación">
              <source src="@/assets/img/video.mp4" type="video/mp4">
              Tu navegador no soporta el elemento de video.
            </video>
            <div class="video-controls" :class="{ 'hidden': !controlsVisible }">
              <button @click="togglePlay($event)" aria-label="Reproducir/Pausar">{{ isPlaying ? 'Pause' : 'Play' }}</button>
              <input type="range" min="0" max="100" v-model="progress" @input="seek" aria-label="Barra de progreso">
            </div>
          </div>
        </div>
        <div class="carousel-item">
          <img src="https://picsum.photos/1200/300?random=1" class="d-block w-100" alt="Imagen aleatoria 1">
        </div>
        <div class="carousel-item">
          <img src="https://picsum.photos/1200/300?random=2" class="d-block w-100" alt="Imagen aleatoria 2">
        </div>
        <div class="carousel-item">
          <img src="https://picsum.photos/1200/300?random=3" class="d-block w-100" alt="Imagen aleatoria 3">
        </div>
      </div>
      <button class="carousel-control-prev" type="button" data-bs-target="#carouselExampleIndicators" data-bs-slide="prev" aria-label="Anterior">
        <span class="carousel-control-prev-icon" aria-hidden="true"></span>
        <span class="visually-hidden">Anterior</span>
      </button>
      <button class="carousel-control-next" type="button" data-bs-target="#carouselExampleIndicators" data-bs-slide="next" aria-label="Siguiente">
        <span class="carousel-control-next-icon" aria-hidden="true"></span>
        <span class="visually-hidden">Siguiente</span>
      </button>
    </div>
  </header>
  <div class="container">
    <div class="row">
      <!-- Filtros de búsqueda -->
      <aside class="col-md-3 mb-4">
        <div class="card">
          <div class="card-body-search">
            <div class="mb-3">
              <input type="text" class="form-control" placeholder="Buscar destino" v-model="localidadBusqueda" aria-label="Buscar destino">
            </div>
            <div class="mb-3">
              <label for="date" class="form-label">Fecha</label>
              <input type="date" id="date" class="form-control" v-model="fechaBusqueda" aria-label="Buscar por fecha">
            </div>
          </div>
        </div>
      </aside>

      <!-- Listado de Tours -->
      <section class="col-md-9">
        <div class="d-flex justify-content-between align-items-center mb-3">
          <div>
            <label for="sort" class="form-label">Ordenar por:</label>
            <select id="sort" class="form-select" v-model="opcionOrden" aria-label="Ordenar por">
              <option value="default">Mejores</option>
              <option value="alphabetical">Alfabético</option>
              <option value="attendees">Cantidad de Asistentes</option>
              <option value="date">Fecha</option>
            </select>
          </div>
          <span class="fw-bold counters">{{ toursOrdenados.length }} rutas encontradas</span>
        </div>
        <div class="row">
          <div class="col-12 mb-4" v-for="tour in toursPaginados" :key="tour.id">
            <div class="card h-100 flex-md-row shadow-sm">
              <img :src="tour.foto" :alt="tour.titulo" class="card-img-top w-100 w-md-50" :aria-label="`Imagen de ${tour.titulo}`">
              <div class="card-body d-flex flex-column justify-content-center">
                <h5 class="card-title">{{ tour.titulo }}</h5>
                <h6 class="card-subtitle mb-2 text-muted">{{ tour.localidad }}</h6>
                <div class="d-flex align-items-center mb-2">
                  <span class="ms-2 text-muted">({{ tour.asistentes }} asistentes)</span>
                </div>
                <p class="card-text">{{ tour.descripcion }}</p>
                <p class="card-text"><small class="text-muted">Hora: {{ tour.hora }}</small></p>
                <p class="card-text"><small class="text-muted">Operador: {{ tour.guia_nombre }}</small></p>
                <p class="card-text"><small class="text-muted">Fecha: {{ tour.fecha }}</small></p>
                <router-link :to="'/rutas/' + tour.id" class="btn btn-secondary mt-auto" aria-label="Reservar ruta {{ tour.titulo }}">Reservar</router-link>
              </div>
            </div>
          </div>
        </div>
        <div class="pagination d-flex justify-content-center mt-3">
          <button @click="paginaAnterior" class="btn btn-secondary me-2" :disabled="paginaActual === 1" aria-label="Página anterior">Anterior</button>
          <span class="align-self-center">Página {{ paginaActual }} de {{ totalPaginas }}</span>
          <button @click="paginaSiguiente" class="btn btn-secondary ms-2" :disabled="paginaActual === totalPaginas" aria-label="Página siguiente">Siguiente</button>
        </div>
      </section>
    </div>
  </div>
</template>

<style scoped>
@import '@/assets/styles/main.css';

/* Estilos del carrusel */
.carousel-indicators button {
  background-color: black;
}

.carousel-indicators button:hover {
  background-color: white;
}

.carousel-control-prev-icon,
.carousel-control-next-icon {
  filter: invert(1);
}

.carousel-control-prev-icon:hover,
.carousel-control-next-icon:hover {
  filter: invert(0.5);
}

.carousel-video, .carousel-item img {
  width: 100%;
  height: 300px;
  object-fit: cover;
}

/* Contenedor y controles del video */
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
  z-index: 10;
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

/* Estilos del buscador */
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
    width: 50%;
  }

  .card-body-search {
    padding: 1rem;
  }
}
</style>