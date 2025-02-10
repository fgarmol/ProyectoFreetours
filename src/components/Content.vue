<script setup>

</script>

<template>
      
      <div class="barraLateral row body-content">
        <div class="bg-secondary text-white p-2 col-3">
          <slot name="sidebar">Sidebar por defecto</slot>
        </div>
        
        <main class="content col-9">
          <slot name="main">Contenido principal</slot>
        </main>
      </div>
  
  </template>
  

  <style scoped>
  .barraLateral{
    flex-grow: 1;
    
  }
 
  
  .sidebar {
    background: #2c3e50;
    color: white;
    padding: 1rem;
  }
  
  .content {
    background: #ecf0f1;
    padding: top;
  }
  </style>
  