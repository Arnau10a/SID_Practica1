// OPERADOR DE CAMPO - AXIS

+flag (F): team(200)
  <-  
  .register_service("fieldops");
  .print("Operador de campo AXIS en defensa de la bandera");
  .goto(F);
  !supply_ammo_regularly.

+target_reached(T): team(200)
  <-  
  .print("He llegado a la bandera, distribuyendo munición");
  .drop_ammo;
  .wait(5000);
  !supply_ammo_regularly.

+!supply_ammo_regularly: team(200)
  <-  
  .wait(15000);
  .drop_ammo;
  .print("Paquete de munición disponible");
  !supply_ammo_regularly.

+msg(Sender, tell, low_ammo): team(200)
  <-  
  .print("Solicitud de munición recibida de ", Sender);
  .send(Sender, tell, coming);
  .goto(Sender).

+target_reached(T): team(200) & helping
  <-  
  .print("He llegado al aliado, suministrando munición");
  .drop_ammo;
  .wait(1000);
  -helping;
  ?flag_position(F);
  .goto(F).

+enemies_in_fov(ID,Type,Angle,Distance,Health,Position): team(200)
  <-  
  .print("Enemigo detectado, atacando mientras distribuyo munición");
  .look_at(Position);
  .shoot(3, Position);
  .wait(500);
  !attack_enemy.

+!attack_enemy: team(200) & enemies_in_fov(ID,Type,Angle,Distance,Health,Position)
  <-  
  .print("Continuando ataque al enemigo");
  .look_at(Position);
  .shoot(3, Position);
  .wait(500);
  !attack_enemy.

+health(H): team(200) & H < 40
  <-  
  .print("¡Salud baja! Buscando cobertura");
  !take_cover.

+!take_cover: team(200)
  <-  
  .print("Buscando cobertura");
  ?base(B);
  .goto(B);
  .wait(3000).
  

// OPERADOR DE CAMPO - ALLIED

+flag (F): team(100)
  <-  
  .register_service("fieldops");
  .print("Operador de campo ALLIED en misión de ataque");
  +objective(F);
  .goto(F);
  !supply_ammo_regularly.

+!supply_ammo_regularly: team(100)
  <-  
  .wait(15000);
  .drop_ammo;
  .print("Paquete de munición disponible");
  !supply_ammo_regularly.

+target_reached(T): team(100) & objective(F)
  <-  
  .print("He llegado al objetivo, apoyando con munición");
  .drop_ammo;
  .turn(0.375);
  .wait(1000).

+msg(Sender, tell, low_ammo): team(100)
  <-  
  .print("Solicitud de munición recibida de ", Sender);
  .send(Sender, tell, coming);
  .goto(Sender).

+target_reached(T): team(100) & helping
  <-  
  .print("He llegado al aliado, suministrando munición");
  .drop_ammo;
  .wait(1000);
  -helping;
  !follow_soldiers.

+flag_taken: team(100)
  <-  
  .print("¡Bandera capturada! Escoltando al portador");
  .get_backups;
  !escort_flag_carrier.

+!escort_flag_carrier: team(100)
  <-  
  .print("Escoltando al portador de la bandera");
  ?base(B);
  .goto(B);
  .drop_ammo;
  .wait(3000);
  !escort_flag_carrier.

+enemies_in_fov(ID,Type,Angle,Distance,Health,Position): team(100)
  <-  
  .print("¡Enemigos cerca! Atacando y distribuyendo munición");
  .drop_ammo;
  .look_at(Position);
  .shoot(4, Position);
  .wait(500);
  !attack_enemy.

+health(H): H < 30
  <-  
  .print("¡Salud crítica! Buscando cobertura");
  .cure;
  !take_cover.
