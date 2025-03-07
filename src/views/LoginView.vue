<script setup>
import { ref } from 'vue';
import router from '@/router';

const emit = defineEmits(['sesionIniciada']);

const form = ref({ usuario: '', password: '' });

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

async function iniciarSesion() {
    const data = { email: form.value.usuario, contraseña: form.value.password };

    try {
        const response = await fetch("http://localhost/APIFreetours/api.php/usuarios?login", {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
            },
            body: JSON.stringify(data),
        });

        if (!response.ok) {
            throw new Error(`Error ${response.status}: ${response.statusText}`);
        }

        const responseData = await response.json();

        if (responseData.status === 'success') {
            emit('sesionIniciada', responseData.user);
            form.value.usuario = '';
            form.value.password = '';
            router.push("/");
        } else {
            showAlert(`Error al iniciar sesión: ${responseData.message}`, false);
        }
    } catch (error) {
        showAlert(`Error al iniciar sesión: ${error.message}`, false);
    }
}
</script>

<template>
    <form @submit.prevent="iniciarSesion" class="m-3">
        <div class="form-group">
        <label for="usuario">Mail</label>
        <input v-model="form.usuario" type="text" id="usuario" class="form-control" placeholder="Usuario" required />
        <label class="mt-3" for="password">Contraseña</label>
        <input v-model="form.password" type="password" class="form-control" placeholder="Contraseña" required />
        <button type="submit" class="btn btn-secondary mt-3">Iniciar Sesión</button>
    </div>
    </form>
    <div id="alert" style="display: none;"></div>
    
    
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

.btn-secondary {
    background-color: black; /* Fondo negro */
    color: white; /* Texto blanco */
    border: none; /* Sin borde */
    transition: background-color 0.3s ease, color 0.3s ease; /* Transición suave */
}

.btn-secondary:hover {
    background-color: white; /* Fondo blanco al pasar el ratón */
    color: black; /* Texto negro al pasar el ratón */
}
.btn-secondary:active{
    background-color: black;
  color: white;
  box-shadow: inset 1px 1px 30px white;
}


.alert {
    background-color: black; /* Fondo negro */
    color: white; /* Texto blanco */
    border: none; /* Sin borde */
    transition: opacity 0.3s ease; /* Transición suave */
}
</style>
