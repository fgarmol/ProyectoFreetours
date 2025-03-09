<script setup>
import { ref } from 'vue';
import router from '@/router';


// Props y eventos emitidos
const props = defineProps({
    usuarioAutenticado: Object
});


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

function iniciarSesion() {
    const data = { email: form.value.usuario, contraseña: form.value.password };

    fetch("http://localhost/APIFreetours/api.php/usuarios?login", {
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
        if (responseData.status === 'success') {
            emit('sesionIniciada', responseData.user);
            form.value.usuario = '';
            form.value.password = '';
            router.push("/");
        } else {
            showAlert(`Error al iniciar sesión: ${responseData.message}`, false);
        }
    })
    .catch(error => {
        showAlert(`Error al iniciar sesión: ${error.message}`, false);
    });
}
</script>

<template>
    <form @submit.prevent="iniciarSesion" class="m-3" aria-labelledby="login-form">
        <div class="form-group">
            <label for="usuario">Mail</label>
            <input v-model="form.usuario" type="text" id="usuario" class="form-control" placeholder="Usuario" required
                aria-required="true" aria-label="Usuario" />
            <label class="mt-3" for="password">Contraseña</label>
            <input v-model="form.password" type="password" id="password" class="form-control" placeholder="Contraseña"
                required aria-required="true" aria-label="Contraseña" />
            <button type="submit" class="btn btn-secondary mt-3" aria-label="Iniciar Sesión">Iniciar Sesión</button>
        </div>
    </form>



</template>

<style scoped>
@import '@/assets/styles/main.css';
</style>
