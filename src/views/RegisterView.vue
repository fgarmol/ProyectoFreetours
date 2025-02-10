<script setup>
import { ref } from 'vue';
const form = ref({ nombre: '', mail: '', password: '' });


    // Función para mostrar alerta
    function showAlert(message, isSuccess = false) {
      const alert = document.getElementById('alert');
      alert.textContent = message;
      alert.style.display = 'block';
      alert.className = isSuccess ? 'alert success' : 'alert';
    }


async function RegistrarUsuario() {
const data = { nombre: form.value.nombre, email: form.value.mail, contraseña: form.value.password };
  
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
    showAlert('Alumno creado exitosamente', true);
    // Limpiar el formulario, mostrar mensaje de redirigir al login
    form.value.nombre = '';
    form.value.mail = '';
    form.value.password = '';

    setTimeout(() => {
      location.href = '/login';
    }, 2000);
    
  })
  .catch(error => showAlert(`Error al crear el alumno: ${error.message}`, false));

}
</script>
<template>
    <form @submit.prevent="RegistrarUsuario()" class="d-flex  align-items-center gap-2">
        
        <label for="nombre">Nombre</label>
        <input v-model="form.nombre" type="text" class="form-control " placeholder="Nombre" required />
        
        <label for="mail">Mail</label>
        <input v-model="form.mail" type="email" class="form-control " placeholder="Mail" required />
        
        <label for="password">Contraseña</label>
        <input v-model="form.password" type="password" class="form-control " placeholder="Contraseña" required />
        <button type="submit" class="btn btn-success">Iniciar Sesión</button>
    </form>
    <div id="alert" class="alert"></div>

</template>