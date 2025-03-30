//TEAM_AXIS

+flag (F): team(200)
  <-
  +flag_position(F);
  .register_service("defender");
  .print("Defendiendo la bandera como AXIS");
  .goto(F).

+target_reached(T): team(200) & flag_position(F)
  <-
  .print("He llegado a la bandera, vigilando el área");
  .turn(0.375);
  .wait(1000);
  +defending;
  -target_reached(T).

+defending: team(200)
  <-
  .turn(0.375);
  .wait(1000);
  +defending.

+enemies_in_fov(ID,Type,Angle,Distance,Health,Position): team(200)
  <-
  -defending;
  .print("Enemigo detectado, atacando");
  .look_at(Position);
  .shoot(3,Position);
  !attack_enemy.

+!attack_enemy: team(200) & enemies_in_fov(ID,Type,Angle,Distance,Health,Position)
  <-
  .print("Atacando al enemigo");
  .look_at(Position);
  .shoot(3, Position);
  .wait(500);
  !attack_enemy.

+!attack_enemy: team(200) & not enemies_in_fov(ID,Type,Angle,Distance,Health,Position)
  <-
  .print("No hay enemigos, volviendo a vigilar");
  ?flag_position(F);
  .goto(F);
  +defending.

+health(H): team(200) & H < 40
  <-
  .print("Salud baja, buscando médico");
  .get_medics;
  .send(medic, tell, saveme);
  .wait(5000);
  ?flag_position(F);
  .goto(F).

//TEAM_ALLIED

+flag (F): team(100)
  <-
  .print("Iniciando misión de captura como ALLIED");
  .register_service("attacker");
  +exploring;
  .goto(F).

+flag_taken: team(100)
  <-
  .print("¡Bandera capturada! Regresando a base");
  ?base(B);
  +returning;
  -exploring;
  .get_backups;
  .goto(B).

+heading(H): exploring
  <-
  .wait(2000);
  .turn(0.375).

+target_reached(T): team(100) & exploring
  <-
  .print("Objetivo alcanzado, explorando el área");
  .turn(0.375).

+target_reached(T): team(100) & returning
  <-
  .print("¡Victoria! Bandera entregada en base");
  +mission_complete.

+enemies_in_fov(ID,Type,Angle,Distance,Health,Position): team(100) & returning & Distance < 15
  <-
  .print("¡Protegiendo la bandera durante el regreso!");
  .look_at(Position);
  .shoot(5,Position);
  !attack_enemy.

+enemies_in_fov(ID,Type,Angle,Distance,Health,Position): team(100)
  <-
  .look_at(Position);
  .shoot(4,Position);
  .goto(Position);
  !attack_enemy.

+!attack_enemy: team(100) & enemies_in_fov(ID,Type,Angle,Distance,Health,Position) & returning
  <-
  .print("Defendiéndome mientras llevo la bandera");
  .look_at(Position);
  .shoot(5, Position);
  .wait(300);
  !attack_enemy.

+!attack_enemy: team(100) & enemies_in_fov(ID,Type,Angle,Distance,Health,Position)
  <-
  .print("Atacando enemigos en modo ofensivo");
  .look_at(Position);
  .shoot(4, Position);
  .wait(500);
  !attack_enemy.

+!attack_enemy: team(100) & not enemies_in_fov(ID,Type,Angle,Distance,Health,Position) & returning
  <-
  .print("Vigilando mientras regreso con la bandera");
  .turn(0.5);
  .wait(300);
  !attack_enemy.

+!attack_enemy: team(100) & not enemies_in_fov(ID,Type,Angle,Distance,Health,Position)
  <-
  .print("Buscando más enemigos o la bandera");
  .turn(0.375);
  .wait(500);
  ?flag(F);
  .goto(F).

+health(H): team(100) & H < 30
  <-
  .print("¡Salud crítica! Buscando cobertura");
  .get_medics;
  +seeking_medic;
  -exploring.

+!evade_enemies: team(100)
  <-
  .print("Ejecutando maniobra evasiva");
  .turn(3.14);
  .goto([0,0,0]).

+ammo(A): A < 20
  <-
  .print("Munición baja, buscando operador de campo");
  .get_fieldops.