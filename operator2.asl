+flag (F): team(200)
  <-
  +flag_position(F);
  .register_service("field_operator");
  .print("Operador de Campo AXIS iniciando defensa de la bandera");
  .goto(F);
  .wait(2000);
  !distribute_ammo_regularly.

+target_reached(T): team(200)
  <-
  .print("He llegado a la bandera, vigilando y reabasteciendo");
  .turn(0.375);
  .wait(1500);
  +defending;
  -target_reached(T).

+defending: team(200)
  <-
  .turn(0.375);
  .wait(1500);
  !check_ammo_requests;
  +defending.

+msg(Sender, tell, need_ammo): team(200)
  <-
  .print("Solicitud de munición recibida de ", Sender);
  -defending;
  +supplying;
  .send(Sender, tell, coming);
  .goto(Sender).

+target_reached(T): supplying & team(200)
  <-
  .print("He llegado al aliado necesitado de munición");
  .give_ammo(Sender);
  .wait(1000);
  -supplying;
  ?flag_position(F);
  .goto(F);
  -target_reached(T).

+enemies_in_fov(ID,Type,Angle,Distance,Health,Position): team(200)
  <-
  .print("¡Enemigo detectado! Tomando posición defensiva");
  .look_at(Position);
  .shoot(3, Position);
  .wait(500);
  !defensive_maneuver.

+!defensive_maneuver: team(200) & enemies_in_fov(ID,Type,Angle,Distance,Health,Position)
  <-
  .print("Realizando maniobra defensiva");
  .look_at(Position);
  .shoot(3, Position);
  .wait(500);
  !defensive_maneuver.

+!distribute_ammo_regularly: team(200)
  <-
  .wait(20000);
  .print("Distribuyendo munición periódicamente");
  !distribute_ammo_regularly.

+flag (F): team(100)
  <-
  .print("Operador de Campo ALLIED iniciando apoyo táctico");
  .register_service("field_operator");
  +objective(F);
  +supporting;
  !follow_soldiers.

+!follow_soldiers: team(100)
  <-
  .get_backups;
  ?objective(F);
  .goto(F);
  .print("Siguiendo a los soldados hacia el objetivo").

+target_reached(T): team(100) & objective(F)
  <-
  .print("He llegado al objetivo");
  .turn(0.375);
  .wait(1000);
  +exploring;
  -target_reached(T).

+msg(Sender, tell, low_ammo): team(100)
  <-
  .print("Aliado con munición baja detectado");
  -exploring;
  +supplying;
  +ally_to_supply(Sender);
  .send(Sender, tell, coming);
  !go_to_ally.

+!go_to_ally: ally_to_supply(Ally) & team(100)
  <-
  .print("Yendo a reabastecer aliado");
  .goto(Ally).

+target_reached(T): supplying & team(100)
  <-
  .print("He llegado al aliado para reabastecer");
  .give_ammo(Sender);
  .wait(1000);
  -supplying;
  -ally_to_supply(_);
  +supporting;
  !follow_soldiers;
  -target_reached(T).

+flag_taken: team(100)
  <-
  .print("¡Bandera capturada! Dando apoyo al portador");
  -exploring;
  +escorting;
  .get_backups;
  !escort_flag_carrier.

+!escort_flag_carrier: team(100)
  <-
  .print("Escoltando al portador de la bandera");
  ?base(B);
  .goto(B);
  .wait(3000);
  !escort_flag_carrier.

+enemies_in_fov(ID,Type,Angle,Distance,Health,Position): team(100)
  <-
  .print("Enemigo detectado, buscando cobertura y dejando munición");
  .get_backups;
  !take_cover.

+!take_cover: team(100)
  <-
  .print("Buscando cobertura contra enemigos");
  ?base(B);
  .goto(B);
  .wait(2000);
  !follow_soldiers.

+ammo(A): A < 20
  <-
  .print("¡Munición baja! Buscando reabastecimiento");
  ?base(B);
  .goto(B);
  !resupply.
