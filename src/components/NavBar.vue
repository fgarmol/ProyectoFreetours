<script setup>
import { ref } from 'vue';
import bootstrapBundle from 'bootstrap/dist/js/bootstrap.bundle';

const props = defineProps({
    datos: Object,
});

</script>

<template>
    <nav class="navbar navbar-expand-lg navbar-light bg-light">
        <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarSupportedContent"
            aria-controls="navbarSupportedContent" aria-expanded="false" aria-label="Toggle navigation">
            <span class="navbar-toggler-icon"></span>
        </button>

        <div class="collapse navbar-collapse" id="navbarSupportedContent">
            <ul class="navbar-nav m-auto">
                <li class="nav-link">
                    <RouterLink class="nav-link" to="/">Home</RouterLink>
                </li>
                <li   class="nav-link"  v-if="datos?.autenticado">
                    <RouterLink class="nav-link" to="/tus-reservas">Mis Reservas</RouterLink>
                </li>
                <!-- se mostrará la seccion de Admin si el rol del usuario es Admin -->
                <li class="nav-link" v-if="datos?.autenticado && datos?.usuario.rol == 'admin'">
                    <div class="dropdown">
                        <button class="btn btn-secondary dropdown-toggle" type="button" id="dropdownMenuButton"
                            data-bs-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                            Admin
                        </button>
                        <div class="dropdown-menu" aria-labelledby="dropdownMenuButton">
                            <RouterLink class="dropdown-item" to="/admin">Usuarios</RouterLink>
                            <RouterLink class="dropdown-item" to="/admin/rutas">Rutas</RouterLink>
                        </div>
                    </div>
                </li>
            </ul>
        </div>
    </nav>
</template>

<style scoped>
.item {
    color: green;
}
</style>