<script setup>
import { ref, computed, onMounted } from 'vue';

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
</script>

<template>
  <div class="container">
    <div class="row">
      <!-- Filtros de búsqueda (Sidebar Filters) -->
      <aside class="col-md-3 mb-4">
        <div class="card">
          <div class="card-body">
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
          <div class="col-md-6 mb-4" v-for="tour in toursPaginados" :key="tour.id">
            <div class="card h-100">
              <img :src="tour.foto" :alt="tour.titulo" class="card-img-top">
              <div class="card-body">
                <h5 class="card-title">{{ tour.titulo }}</h5>
                <h6 class="card-subtitle mb-2 text-muted">{{ tour.localidad }}</h6>
                <div class="d-flex align-items-center mb-2">
                  <span class="text-warning">⭐⭐⭐⭐⭐</span>
                  <span class="ms-2 text-muted">({{ tour.asistentes }} asistentes)</span>
                </div>
                <p class="card-text">{{ tour.descripcion }}</p>
                <p class="card-text"><small class="text-muted">Duración: {{ tour.hora }}</small></p>
                <p class="card-text"><small class="text-muted">Operador: {{ tour.guia_nombre }}</small></p>
                <p class="card-text"><small class="text-muted">Fecha: {{ tour.fecha }}</small></p>
                <router-link :to="'/rutas/' + tour.id" class="btn btn-primary">Reservar</router-link>
              </div>
            </div>
          </div>
        </div>
        <div class="d-flex justify-content-center">
          <button @click="paginaAnterior" class="btn btn-secondary me-2" :disabled="paginaActual === 1">Anterior</button>
          <span class="align-self-center">Página {{ paginaActual }} de {{ totalPaginas }}</span>
          <button @click="paginaSiguiente" class="btn btn-secondary ms-2" :disabled="paginaActual === totalPaginas">Siguiente</button>
        </div>
      </section>
    </div>
  </div>
</template>

<style scoped>
.card-img-top {
  height: 200px;
  object-fit: cover;
}
</style>