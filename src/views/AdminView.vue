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

function tieneRutasAsignadas(usuarioId) {
  return fetch(`http://localhost/APIFreetours/api.php/asignaciones?guia_id=${usuarioId}`)
    .then(response => {
      if (!response.ok) {
        throw new Error(`Error ${response.status}: ${response.statusText}`);
      }
      return response.json();
    })
    .then(data => {
      return data.length > 0;
    })
    .catch(error => {
      console.error('Error al comprobar rutas asignadas:', error);
      showAlert(`Error al comprobar rutas asignadas: ${error.message}`, false);
      return false;
    });
}

function actualizarRol(usuario) {
  
  tieneRutasAsignadas(usuario.id).then(tieneRutas => {
    if (tieneRutas && usuario.rol !== 'guia') {
      showAlert('No se puede cambiar el rol de un guía con rutas asignadas', false);
      usuario.rol = 'guia'; // Revertir el cambio de rol
      return;
    }

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
      .then(data => {
        console.log('Respuesta:', data);
        showAlert('Rol actualizado exitosamente', true);
      })
      .catch(error => {
        console.error('Error:', error);
        showAlert(`Error al actualizar el rol: ${error.message}`, false);
      });
  }).catch(error => {
    console.error('Error al verificar rutas asignadas:', error);
    showAlert(`Error al verificar rutas asignadas: ${error.message}`, false);
  });
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
    <button class="btn btn-secondary mb-3" @click="mostrarModalCrearUsuario">Crear Usuario</button>
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
      <button @click="paginaAnterior" :disabled="paginaActual === 1" class="btn btn-secondary me-2">Anterior</button>
      <span class="align-self-center">Página {{ paginaActual }} de {{ totalPaginas }}</span>
      <button @click="paginaSiguiente" :disabled="paginaActual === totalPaginas" class="btn btn-secondary ms-2">Siguiente</button>
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
            <button type="submit" class="btn btn-secondary">Crear</button>
          </form>
        </div>
      </div>
    </div>
  </div>
</template>

<style scoped>
body {
    background-color: white; /* Fondo blanco */
    color: black; /* Texto negro */
}

.container {
    padding-bottom: 5rem;
    background-color: white; /* Fondo blanco */
    color: black; /* Texto negro */
}

.table {
    background-color: white; /* Fondo blanco */
    border: 1px solid black; /* Borde negro */
    transition: transform 0.3s ease, box-shadow 0.3s ease; /* Transición suave */
}

.table th, .table td {
    color: black; /* Texto negro */
}

.table-striped tbody tr:nth-of-type(odd) {
    background-color: #f9f9f9; /* Fondo gris claro para filas impares */
}

.table-striped tbody tr:hover {
    background-color: #f1f1f1; /* Fondo gris claro al pasar el ratón */
}

 .btn-secondary {
  background-color: black; /* Fondo negro */
  color: white; /* Texto blanco */
  border: none; /* Sin borde */
  transition: background-color 0.3s ease, color 0.3s ease; /* Transición suave */
}

.btn-secondary:hover {
  background-color: whitesmoke; /* Fondo blanco al pasar el ratón */
  color: black; /* Texto negro al pasar el ratón */
  box-shadow: 0 4px 8px rgba(0, 0, 0, 0.2); /* Efecto de sombra */
  transform: scale(1.05); /* Transición de escala */
  transition: transform 0.3s ease, box-shadow 0.3s ease; /* Transición suave */
}

.btn-danger {
  background-color: black; /* Fondo negro */
  color: white; /* Texto blanco */
  border: none; /* Sin borde */
  transition: background-color 0.3s ease, color 0.3s ease, transform 0.3s ease; /* Transición suave */
}

.btn-danger:hover {
  background-color: red; /* Fondo rojo al pasar el ratón */
  color: white; /* Texto blanco al pasar el ratón */
  transform: scale(1.1);
  box-shadow: 0 4px 8px rgba(0, 0, 0, 0.2); /* Efecto de sombra */
  transition: transform 0.3s ease, box-shadow 0.3s ease; /* Transición suave */ /* Efecto de escala al pasar el ratón */
}

.modal-content {
    background-color: white; /* Fondo blanco */
    color: black; /* Texto negro */
    border: 1px solid black; /* Borde negro */
}

.modal-header, .modal-footer {
    border-bottom: 1px solid black; /* Borde negro */
}

.modal-header .btn-close {
    color: black; /* Texto negro */
}

.pagination {
    display: flex;
    justify-content: center;
    align-items: center;
    margin-top: 1rem;
}

.form-select {
  background-color: white; /* Fondo blanco */
  color: black; /* Texto negro */
  border: 1px solid black; /* Borde negro */
  transition: background-color 0.3s ease, color 0.3s ease; /* Transición suave */
}

.form-select:hover {
  background-color: #f1f1f1; /* Fondo gris claro al pasar el ratón */
  color: black; /* Texto negro al pasar el ratón */
}

.pagination button {
    margin: 0 0.5rem;
}

.counters {
    margin: 1rem 0;
}
</style>