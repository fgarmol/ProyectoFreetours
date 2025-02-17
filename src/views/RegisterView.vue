<script setup>
import router from '@/router';
import { ref } from 'vue';
const form = ref({ nombre: '', mail: '', password: '' });


// Función para mostrar alerta
function showAlert(message, isSuccess = false) {
  const alert = document.getElementById('alert');
  alert.textContent = message;
  alert.style.display = 'block';
  alert.className = isSuccess ? 'alert success' : 'alert';
}

function RegistrarUsuario() {
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
      return response.text(); // Cambia a .text() para ver el contenido completo
    })
    .then(responseText => {
      console.log('Respuesta del servidor:', responseText); // Verifica la respuesta completa
      try {
        const responseData = JSON.parse(responseText); // Intenta convertir la respuesta en JSON
        showAlert('Alumno creado exitosamente', true);

        form.value.nombre = '';
        form.value.mail = '';
        form.value.password = '';

        setTimeout(() => {
          router.push('/login');
        }, 2000);

      } catch (e) {
        console.error("La respuesta no es un JSON válido:", e);
        showAlert('Error al crear el alumno: La respuesta no es un JSON válido', false);
      }
    })
    .catch(error => showAlert(`Error al crear el alumno: ${error.message}`, false));
}

</script>
<template>
  <form @submit.prevent="RegistrarUsuario()" class="m-3">
    <div class="form-group">

      <label for="nombre">Nombre</label>
      <input v-model="form.nombre" type="text" class="form-control " placeholder="Nombre" required />

      <label for="mail">Mail</label>
      <input v-model="form.mail" type="email" class="form-control " placeholder="Mail" required />

      <label for="password">Contraseña</label>
      <input v-model="form.password" type="password" class="form-control " placeholder="Contraseña" required />

      <button type="submit" class="btn btn-success mt-3">Registrarse</button>
    </div>
  </form>
  <div id="alert" class="alert"></div>

</template>