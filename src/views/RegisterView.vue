<script setup>
import router from '@/router';
import { ref, watch } from 'vue';

const form = ref({ nombre: '', mail: '', password: '', confirmPassword: '' });
const errors = ref({ nombre: '', mail: '', password: '', confirmPassword: '' });
const touched = ref({ nombre: false, mail: false, password: false, confirmPassword: false });

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

function validateNombre() {
  if (form.value.nombre.length < 3) {
    errors.value.nombre = 'El nombre debe tener al menos 3 caracteres';
  } else {
    errors.value.nombre = '';
  }
}

function validateMail() {
  const emailPattern = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
  if (!emailPattern.test(form.value.mail)) {
    errors.value.mail = 'El correo electrónico no es válido';
  } else {
    errors.value.mail = '';
  }
}

function validatePassword() {
  const passwordPattern = /^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$/;
  if (!passwordPattern.test(form.value.password)) {
    errors.value.password = 'La contraseña debe tener al menos 8 caracteres, incluir una letra mayúscula, una letra minúscula, un número y un carácter especial';
  } else {
    errors.value.password = '';
  }
}

function validateConfirmPassword() {
  if (form.value.password !== form.value.confirmPassword) {
    errors.value.confirmPassword = 'Las contraseñas no coinciden';
  } else {
    errors.value.confirmPassword = '';
  }
}

watch(form.value, (newVal, oldVal) => {
  if (touched.value.nombre) validateNombre();
  if (touched.value.mail) validateMail();
  if (touched.value.password) validatePassword();
  if (touched.value.confirmPassword) validateConfirmPassword();
}, { deep: true });

function validateForm() {
  validateNombre();
  validateMail();
  validatePassword();
  validateConfirmPassword();

  return !errors.value.nombre && !errors.value.mail && !errors.value.password && !errors.value.confirmPassword;
}

function RegistrarUsuario() {
  if (!validateForm()) {
    return;
  }

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
        form.value.confirmPassword = '';

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
      <input v-model="form.nombre" @focus="touched.nombre = true" @blur="validateNombre" type="text" class="form-control" placeholder="Nombre" required />
      <span class="text-danger" v-if="touched.nombre">{{ errors.nombre }}</span>

      <label for="mail">Mail</label>
      <input v-model="form.mail" @focus="touched.mail = true" @blur="validateMail" type="email" class="form-control" placeholder="Mail" required />
      <span class="text-danger" v-if="touched.mail">{{ errors.mail }}</span>

      <label for="password">Contraseña</label>
      <input v-model="form.password" @focus="touched.password = true" @blur="validatePassword" type="password" class="form-control" placeholder="Contraseña" required />
      <span class="text-danger" v-if="touched.password">{{ errors.password }}</span>

      <label for="confirmPassword">Confirmar Contraseña</label>
      <input v-model="form.confirmPassword" @focus="touched.confirmPassword = true" @blur="validateConfirmPassword" type="password" class="form-control" placeholder="Confirmar Contraseña" required />
      <span class="text-danger" v-if="touched.confirmPassword">{{ errors.confirmPassword }}</span>

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

.text-danger {
    color: red;
    display: block;
    margin-top: 0.25rem;
    font-size: 0.875rem;
}
</style>