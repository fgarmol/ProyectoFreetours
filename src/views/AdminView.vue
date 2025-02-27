<script setup>
import { onMounted, ref, computed } from 'vue';
import router from '@/router';

const props = defineProps({
  usuarioAutenticado: Object
});

const emits = defineEmits(['sesionIniciada']);

const users = ref([]);
const paginaActual = ref(1);
const itemsPorPagina = 10; // Número de usuarios por página
const showModalCrearUsuario = ref(false);

const mostrarModalCrearUsuario = () => {
  showModalCrearUsuario.value = true;
};

const cerrarModalCrearUsuario = () => {
  clearForm();
  showModalCrearUsuario.value = false;
};

const newUser = ref({
  nombre: '',
  email: '',
  contraseña: '',
  cuentaHabilitada: 'true'
});

function showAlert(message, isSuccess = false) {
  const alert = document.getElementById('alert');
  alert.textContent = message;
  alert.style.display = 'block';
  alert.className = isSuccess ? 'alert success' : 'alert';
}

function clearForm() {
  newUser.value.nombre = '';
  newUser.value.email = '';
  newUser.value.contraseña = '';
}

function cargarUsuarios() {
  fetch("http://localhost/APIFreetours/api.php/usuarios")
    .then(response => {
      if (!response.ok) {
        throw new Error(`Error ${response.status}: ${response.statusText}`);
      }
      return response.json();
    })
    .then(data => {
      users.value = data;
      console.log(data);
    })
    .catch(error => showAlert(`Error al obtener usuarios: ${error.message}`));
}

onMounted(() => {
  if (props.usuarioAutenticado.autenticado && props.usuarioAutenticado.usuario.rol === 'admin') {
    cargarUsuarios();
  } else {
    router.push('/');
  }
});

function crearUsuario() {
  const data = { nombre: newUser.value.nombre, email: newUser.value.email, contraseña: newUser.value.contraseña, rol: 'usuario' };
  fetch("http://localhost/APIFreetours/api.php/usuarios", {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
    },
    body: JSON.stringify(data),
  })
    .then(response => {
      if (!response.ok) {
        throw new Error(`Error ${response.status}: ${response.statusText}`);
      }
      return response.json();
    })
    .then(responseData => {
      showAlert('Usuario creado exitosamente', true);
      newUser.value.nombre = '';
      newUser.value.email = '';
      newUser.value.contraseña = '';
      cerrarModalCrearUsuario();
      cargarUsuarios();
    })
    .catch(error => showAlert(`Error al crear el usuario: ${error.message}`, false));
}

function actualizarRol(usuario) {
  const updatedRole = {
    rol: usuario.rol
  };
  fetch(`http://localhost/APIFreetours/api.php/usuarios?id=${usuario.id}`, {
    method: 'PUT',
    headers: {
      'Content-Type': 'application/json'
    },
    body: JSON.stringify(updatedRole)
  })
    .then(response => response.json())
    .then(data => console.log('Respuesta:', data))
    .catch(error => console.error('Error:', error));
}

function eliminarUsuario(id) {
  if (!confirm('¿Estás seguro de que deseas eliminar este usuario?')) {
    return;
  }
  fetch(`http://localhost/APIFreetours/api.php/usuarios?id=${id}`, {
    method: 'DELETE',
  })
    .then(response => {
      if (!response.ok) {
        throw new Error(`Error ${response.status}: ${response.statusText}`);
      }
      return response.json();
    })
    .then(responseData => {
      showAlert('Usuario eliminado exitosamente', true);
      cargarUsuarios();
    })
    .catch(error => showAlert(`Error al eliminar el usuario: ${error.message}`, false));
}

const usuariosPaginados = computed(() => {
  const inicio = (paginaActual.value - 1) * itemsPorPagina;
  const fin = inicio + itemsPorPagina;
  return users.value.slice(inicio, fin);
});

const totalPaginas = computed(() => {
  return Math.ceil(users.value.length / itemsPorPagina);
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

const totalUsuarios = computed(() => users.value.length);

</script>

<template>
  <div class="container">
    <h1>Administrar usuarios</h1>
    <div id="alert" class="alert"></div>
    <button class="btn btn-primary mb-3" @click="mostrarModalCrearUsuario">Crear Usuario</button>
    <div class="counters d-flex justify-content-end mb-3">
      <span class="fw-bold">Total de usuarios: {{ totalUsuarios }}</span>
    </div>
    
    <div class="table-responsive">
      <table class="table table-striped">
        <thead>
          <tr>
            <th>id</th>
            <th>Nombre</th>
            <th>Email</th>
            <th>Contraseña</th>
            <th>Rol</th>
            <th>Acciones</th>
          </tr>
        </thead>
        <tbody>
          <tr v-for="usuario in usuariosPaginados" :key="usuario.id">
            <td>{{ usuario.id }}</td>
            <td>{{ usuario.nombre }}</td>
            <td>{{ usuario.email }}</td>
            <td>{{ usuario.contraseña }}</td>
            <td>
              <select v-model="usuario.rol" @change="actualizarRol(usuario)" class="form-select">
                <option value="admin">Administrador</option>
                <option value="guia">Guía</option>
                <option value="cliente">Cliente</option>
              </select>
            </td>
            <td>
              <button class="btn btn-danger btn-sm" @click="eliminarUsuario(usuario.id)">Eliminar</button>
            </td>
          </tr>
        </tbody>
      </table>
    </div>
    
    <div class="pagination d-flex justify-content-center mt-3">
      <button @click="paginaAnterior" :disabled="paginaActual === 1" class="btn btn-primary btn-sm">Anterior</button>
      <span class="mx-2">Página {{ paginaActual }} de {{ totalPaginas }}</span>
      <button @click="paginaSiguiente" :disabled="paginaActual === totalPaginas" class="btn btn-primary btn-sm">Siguiente</button>
    </div>
  </div>

  <div v-if="showModalCrearUsuario" class="modal" tabindex="-1" role="dialog" style="display: block;">
    <div class="modal-dialog" role="document">
      <div class="modal-content">
        <div class="modal-header">
          <h5 class="modal-title">Crear Usuario</h5>
          <button type="button" class="btn-close" @click="cerrarModalCrearUsuario"></button>
        </div>
        <div class="modal-body">
          <form @submit.prevent="crearUsuario">
            <div class="mb-3">
              <label for="nombre" class="form-label">Nombre</label>
              <input type="text" v-model="newUser.nombre" class="form-control" id="nombre" required>
            </div>
            <div class="mb-3">
              <label for="email" class="form-label">Email</label>
              <input type="email" v-model="newUser.email" class="form-control" id="email" required>
            </div>
            <div class="mb-3">
              <label for="contraseña" class="form-label">Contraseña</label>
              <input type="password" v-model="newUser.contraseña" class="form-control" id="contraseña" required>
            </div>
            <button type="submit" class="btn btn-primary">Crear</button>
          </form>
        </div>
      </div>
    </div>
  </div>
</template>

<style scoped>
footer {
  margin-top: auto;
  background-color: #f1f1f1;
  text-align: center;
  padding: 10px;
}

.container {
  flex: 1;
  overflow-y: auto;
  padding-bottom: 5rem;
}

body,
html {
  margin: 0;
  padding: 0;
  height: 100%;
}

.layout {
  display: flex;
  flex-direction: column;
  height: 100vh;
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

.counters {
  margin: 1rem 0;
}
</style>