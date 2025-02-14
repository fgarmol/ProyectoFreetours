<script setup>
import { ref, onMounted } from 'vue';
import Header from '@/components/Header.vue';

const props = defineProps({
  title: String,
  usuarioAutenticado: {
    type: Object,
    required: true
  }
});

const tours = ref([]);

function cargarRutas() {
  fetch('http://localhost/APIFreetours/api.php/rutas', {
    method: 'GET',
  })
    .then(response => response.json())
    .then(data => {
      tours.value = data;
      console.log('Rutas:', data);
    })
    .catch(error => console.error('Error:', error));
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
          <input type="text" placeholder="Buscar destino">
          <button class="search-btn">🔍</button>
        </div>
        <div class="filters">
          <label for="date">Fecha</label>
          <input type="date" id="date">
          <label for="price">Rango de precios</label>
          <input type="range" id="price" min="0" max="600">
          <div class="rating-filters">
            <button>Todos</button>
            <button>9+</button>
            <button>8+</button>
            <button>7+</button>
            <button>6+</button>
          </div>
          <label for="time">Hora de inicio</label>
          <input type="time" id="time">
        </div>
      </aside>

      <!-- Listado de Tours (Tour List) -->
      <section class="tour-list">
        <div class="sorting">
          <label for="sort">Ordenar por:</label>
          <select id="sort">
            <option value="default">Por Defecto</option>
            <option value="best-rated">Mejor Valorados</option>
            <option value="most-booked">Más Reservados</option>
          </select>
        </div>
        <div class="tours">
          <div class="tour-card" v-for="tour in tours" :key="tour.id">
            <img :src="tour.foto" alt="" class="tour-image">
            <div class="tour-info">
              <span class="category">{{ tour.localidad }}</span>
              <h2>{{ tour.titulo }}</h2>
              <div class="rating">
                <span class="reviews">({{ tour.asistentes }} asistentes)</span>
              </div>
              <p>{{ tour.descripcion }}</p>
              <p>Duración: {{ tour.hora }}</p>
              <p>Operador: {{ tour.guia_nombre }}</p>
              <p>Precio: {{ tour.precio ? tour.precio : 'Gratis' }}</p>
              <button class="btn">Reservar</button>
            </div>
          </div>
        </div>
      </section>
    </div>
  </div>
</template>

<style scoped>
.hero {
  position: relative;
  text-align: center;
  color: white;
}

.hero-image {
  width: 100%;
  height: auto;
}

.hero-text {
  position: absolute;
  top: 50%;
  left: 50%;
  transform: translate(-50%, -50%);
}

.main-content {
  display: flex;
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

.tour-card {
  border: 1px solid #ddd;
  padding: 1rem;
  margin-bottom: 1rem;
  border-radius: 8px;
  background: white;
  box-shadow: 2px 2px 10px rgba(0, 0, 0, 0.1);
}

.tour-image {
  width: 100%;
  height: auto;
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
</style>