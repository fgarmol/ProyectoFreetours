<script setup>
import router from '@/router';
import { ref } from 'vue';
const form = ref({ nombre: '', mail: '', password: '' });


// Función para mostrar alerta
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
        }, 1000);

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
  

</template>
<style scoped>
body {
    background-color: white; /* Fondo blanco */
    color: black; /* Texto negro */
}

.form-group {
    margin-bottom: 1rem;
}

label {
    color: black; /* Texto negro */
    font-weight: bold;
}

input {
    background-color: white; /* Fondo blanco */
    color: black; /* Texto negro */
    border: 1px solid black; /* Borde negro */
    transition: border-color 0.3s ease, box-shadow 0.3s ease; /* Transición suave */
}

input:focus {
    border-color: black; /* Borde negro al enfocar */
    box-shadow: 0 0 5px rgba(0, 0, 0, 0.1); /* Sombra suave */
}

.btn-success {
    background-color: black; /* Fondo negro */
    color: white; /* Texto blanco */
    border: none; /* Sin borde */
    transition: background-color 0.3s ease, color 0.3s ease; /* Transición suave */
}

.btn-success:hover {
    background-color: white; /* Fondo blanco al pasar el ratón */
    color: black; /* Texto negro al pasar el ratón */
}

.alert {
    background-color: black; /* Fondo negro */
    color: white; /* Texto blanco */
    border: none; /* Sin borde */
    transition: opacity 0.3s ease; /* Transición suave */
}
</style>