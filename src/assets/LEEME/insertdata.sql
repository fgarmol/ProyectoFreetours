USE free_tours;

-- Insertar Usuarios (Administrador, Guías, Clientes)
INSERT INTO usuarios (nombre, email, contraseña, rol) VALUES
('Admin', 'admin@tours.com', 'admin123', 'admin'),
('Guía 1', 'guia1@tours.com', 'pass123', 'guia'),
('Guía 2', 'guia2@tours.com', 'pass123', 'guia'),
('Cliente 1', 'cliente1@tours.com', 'pass123', 'cliente'),
('Cliente 2', 'cliente2@tours.com', 'pass123', 'cliente');

-- Insertar Rutas
INSERT INTO rutas (titulo, localidad, descripcion, foto, fecha, hora, latitud, longitud) VALUES
('Ruta Histórica', 'Madrid', 'Visita por lugares emblemáticos.', 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSfqfnWVWFzvFCRW6dX2MB6Cnho6uaLjltLNQ&s', '2025-02-10', '10:00', 40.4168, -3.7038),
('Ruta Natural', 'Barcelona', 'Senderismo por paisajes naturales.', 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSfqfnWVWFzvFCRW6dX2MB6Cnho6uaLjltLNQ&s', '2025-02-11', '09:00', 41.3784, 2.1915),
('Ruta Cultural', 'Sevilla', 'Recorrido por monumentos históricos.', 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSfqfnWVWFzvFCRW6dX2MB6Cnho6uaLjltLNQ&s', '2025-02-12', '11:00', 37.3886, -5.9823),
('Ruta Gastronómica', 'Valencia', 'Tour de tapas y platos típicos.', 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSfqfnWVWFzvFCRW6dX2MB6Cnho6uaLjltLNQ&s', '2025-02-13', '13:00', 39.4699, -0.3763),
('Ruta de Senderismo', 'Granada', 'Caminata por la Alpujarra.', 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSfqfnWVWFzvFCRW6dX2MB6Cnho6uaLjltLNQ&s', '2025-02-14', '08:00', 37.1773, -3.5986),
('Ruta de Arte', 'Bilbao', 'Visita a museos y galerías.', 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSfqfnWVWFzvFCRW6dX2MB6Cnho6uaLjltLNQ&s', '2025-02-15', '10:00', 43.2630, -2.9340),
('Ruta de Compras', 'Madrid', 'Tour por tiendas de lujo.', 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSfqfnWVWFzvFCRW6dX2MB6Cnho6uaLjltLNQ&s', '2025-02-16', '12:00', 40.4168, -3.7038),
('Ruta de Aventura', 'Barcelona', 'Actividades extremas en la naturaleza.', 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSfqfnWVWFzvFCRW6dX2MB6Cnho6uaLjltLNQ&s', '2025-02-17', '14:00', 41.3784, 2.1915),
('Ruta Histórica', 'Sevilla', 'Recorrido por monumentos históricos.', 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSfqfnWVWFzvFCRW6dX2MB6Cnho6uaLjltLNQ&s', '2025-02-18', '10:00', 37.3886, -5.9823),
('Ruta Natural', 'Valencia', 'Senderismo por paisajes naturales.', 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSfqfnWVWFzvFCRW6dX2MB6Cnho6uaLjltLNQ&s', '2025-02-19', '09:00', 39.4699, -0.3763),
('Ruta Cultural', 'Granada', 'Visita a monumentos históricos.', 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSfqfnWVWFzvFCRW6dX2MB6Cnho6uaLjltLNQ&s', '2025-02-20', '11:00', 37.1773, -3.5986),
('Ruta Gastronómica', 'Bilbao', 'Tour de pintxos y platos típicos.', 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSfqfnWVWFzvFCRW6dX2MB6Cnho6uaLjltLNQ&s', '2025-02-21', '13:00', 43.2630, -2.9340),
('Ruta de Senderismo', 'Madrid', 'Caminata por la Sierra de Guadarrama.', 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSfqfnWVWFzvFCRW6dX2MB6Cnho6uaLjltLNQ&s', '2025-02-22', '08:00', 40.4168, -3.7038),
('Ruta de Arte', 'Barcelona', 'Visita a museos y galerías de arte.', 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSfqfnWVWFzvFCRW6dX2MB6Cnho6uaLjltLNQ&s', '2025-02-23', '10:00', 41.3784, 2.1915),
('Ruta de Compras', 'Sevilla', 'Tour por tiendas de artesanía local.', 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSfqfnWVWFzvFCRW6dX2MB6Cnho6uaLjltLNQ&s', '2025-02-24', '12:00', 37.3886, -5.9823),
('Ruta de Aventura', 'Valencia', 'Actividades acuáticas en la costa.', 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSfqfnWVWFzvFCRW6dX2MB6Cnho6uaLjltLNQ&s', '2025-02-25', '14:00', 39.4699, -0.3763),
('Ruta Histórica', 'Granada', 'Recorrido por la Alhambra y alrededores.', 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSfqfnWVWFzvFCRW6dX2MB6Cnho6uaLjltLNQ&s', '2025-02-26', '10:00', 37, -7.3234)

 



-- Insertar Asignaciones de Guías a Rutas
INSERT INTO asignaciones (ruta_id, guia_id) VALUES
(1, 2), -- Guía 2 asignado a la Ruta 1
(2, 3); -- Guía 3 asignado a la Ruta 2

-- Insertar Reservas de Clientes
INSERT INTO reservas (ruta_id, cliente_id, num_personas) VALUES
(1, 4, 2), -- Cliente 1 reservó para 2 personas en la Ruta 1
(2, 5, 3); -- Cliente 2 reservó para 3 personas en la Ruta 2

-- Insertar Valoraciones de Rutas
INSERT INTO valoraciones (ruta_id, cliente_id, puntuacion, comentario) VALUES
(1, 4, 5, 'Excelente recorrido, muy informativo!'),
(2, 5, 4, 'Muy interesante, pero un poco largo.');
