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
  <div>
    <div class="main-content">
      <!-- Filtros de búsqueda (Sidebar Filters) -->
      <aside class="sidebar">
        <div class="search">
          <input type="text" placeholder="Buscar destino" v-model="localidadBusqueda">
        </div>
        <div class="filters">
          <label for="date">Fecha</label>
          <input type="date" id="date" v-model="fechaBusqueda">
        </div>
      </aside>

      <!-- Listado de Tours (Tour List) -->
      <section class="tour-list">
        <div class="sorting">
          <label for="sort">Ordenar por:</label>
          <select id="sort" v-model="opcionOrden">
            <option value="default">Mejores</option>
            <option value="alphabetical">Alfabético</option>
            <option value="attendees">Cantidad de Asistentes</option>
            <option value="date">Fecha</option>
          </select>
          <span class="tour-count">{{ toursOrdenados.length }} rutas encontradas</span>
        </div>
        <div class="tours">
          <div class="tour-card" v-for="tour in toursPaginados" :key="tour.id">
            <img :src="tour.foto" :alt="tour.titulo" class="tour-image">
            <div class="tour-info">
              <span class="category">{{ tour.localidad }}</span>
              <h2>{{ tour.titulo }}</h2>
              <div class="rating">
                <span class="stars">⭐⭐⭐⭐⭐</span>
                <span class="reviews">({{ tour.asistentes }} asistentes)</span>
              </div>
              <p>{{ tour.descripcion }}</p>
              <p>Duración: {{ tour.hora }}</p>
              <p>Operador: {{ tour.guia_nombre }}</p>
              <p>Fecha: {{ tour.fecha }}</p>
              <router-link :to="'/rutas/' + tour.id">
                <button class="reserve-button">Reservar</button>
              </router-link>

            </div>
          </div>
        </div>
        <div class="pagination">
          <button @click="paginaAnterior" :disabled="paginaActual === 1">Anterior</button>
          <span>Página {{ paginaActual }} de {{ totalPaginas }}</span>
          <button @click="paginaSiguiente" :disabled="paginaActual === totalPaginas">Siguiente</button>
        </div>
      </section>
    </div>
  </div>
</template>

<style scoped>
.main-content {
  display: flex;
  margin-bottom: 5rem;
}

.sidebar {
  width: 25%;
  padding: 1rem;
  background-color: #f0f0f0;
}

.tour-list {
  width: 75%;
  padding: 1rem;
}

.sorting {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 1rem;
}

.tour-count {
  font-weight: bold;
}

.tour-card {
  display: flex;
  /* Cambia el diseño a flexbox */
  border: 1px solid #ddd;
  padding: 1rem;
  margin-bottom: 1rem;
  border-radius: 8px;
  background: white;
  box-shadow: 2px 2px 10px rgba(0, 0, 0, 0.1);
}

.tour-image {
  width: 150px;
  /* Ajusta el ancho según tus necesidades */
  height: auto;
  /* Mantén la proporción de la imagen */
  object-fit: cover;
  /* Asegura que la imagen cubra el contenedor sin distorsionarse */
  border-radius: 8px;
  /* Opcional: añade bordes redondeados */
  margin-right: 1rem;
  /* Añade espacio entre la imagen y la información */
}

.tour-info {
  padding: 1rem;
}

.category {
  background-color: #ffcc00;
  padding: 0.2rem 0.5rem;
  border-radius: 4px;
}

.rating {
  display: flex;
  align-items: center;
}

.stars {
  color: #ffcc00;
}

.reviews {
  margin-left: 0.5rem;
  color: #888;
}

.pagination {
  display: flex;
  justify-content: center;
  align-items: center;
  margin-top: 1rem;
}

.pagination button {
  margin: 0 0.5rem;
}
</style>