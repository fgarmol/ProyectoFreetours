<script setup>
import { ref } from 'vue';
import router from '@/router';

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
@import '@/assets/styles/main.css';



</style>
