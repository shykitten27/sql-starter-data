drop table plant;
drop table seeds;  
drop table garden_bed;

CREATE TABLE plant (
   plant_id INTEGER PRIMARY KEY AUTO_INCREMENT,
   plant_name VARCHAR(100), 
   zone integer, 
   season varchar(6)
);

CREATE TABLE seeds (
   seed_id INTEGER PRIMARY KEY AUTO_INCREMENT,
   expiration_date date, 
   quantity integer, 
   reorder boolean,
   plant_id integer,
   FOREIGN KEY (plant_id) REFERENCES plant(plant_id)
);

CREATE TABLE garden_bed (
   space_number INTEGER PRIMARY KEY AUTO_INCREMENT,
   date_planted date, 
   doing_well boolean,
   plant_id integer,
   FOREIGN KEY (plant_id) REFERENCES plant(plant_id)
);

## inner join on seeds & garden_bed
select gb.space_number, s.seed_id, gb.date_planted, gb.doing_well from garden_bed gb
inner join seeds s 
on gb.plant_id = s.plant_id;

## left join seeds & garden_bed
select gb.space_number, s.seed_id, gb.date_planted, gb.doing_well from seeds s
left join garden_bed gb
on gb.plant_id = s.plant_id;

## right join
select gb.space_number, s.seed_id, gb.date_planted, gb.doing_well from seeds s
right join garden_bed gb
on gb.plant_id = s.plant_id;

## full join (not supported so use Left Union Right)
select gb.space_number, s.seed_id, gb.date_planted, gb.doing_well from seeds s
left join garden_bed gb
on gb.plant_id = s.plant_id
UNION
select gb.space_number, s.seed_id, gb.date_planted, gb.doing_well from seeds s
right join garden_bed gb
on gb.plant_id = s.plant_id;


## inner join versus subquery
## which plants are in garden bed using inner join on seeds and garden_bed
## use DISTINCT keyword to narrow results
     
select DISTINCT p.plant_name, p.plant_id 
from plant p
	inner join seeds s
		on p.plant_id = s.plant_id
	inner join garden_bed gb
		on s.plant_id = gb.plant_id;        

## as subquery
## use ANY keyword to narrow results
select p.plant_name, p.plant_id from plant p
where p.plant_id = any
	(select s.plant_id from seeds s where s.plant_id = any
		(select gb.plant_id from garden_bed gb));
        
        
select * from seeds;

## insert a row for hostas into the plant table using a subquery to obtain the plant_id based on plant_name from plant table
insert into seeds (expiration_date, quantity, reorder, plant_id)
values ('2020-08-05', 100, 0, 
 (SELECT plant_id FROM plant WHERE (plant_name LIKE 'Hosta')) 
 );
 
select * from seeds;

## bonus 
## UNION ALL vs  UNION
select gb.space_number, s.seed_id, gb.date_planted, gb.doing_well from seeds s
left join garden_bed gb
on gb.plant_id = s.plant_id
UNION ALL
select gb.space_number, s.seed_id, gb.date_planted, gb.doing_well from seeds s
right join garden_bed gb
on gb.plant_id = s.plant_id;

select gb.space_number, s.seed_id, gb.date_planted, gb.doing_well from seeds s
left join garden_bed gb
on gb.plant_id = s.plant_id
UNION 
select gb.space_number, s.seed_id, gb.date_planted, gb.doing_well from seeds s
right join garden_bed gb
on gb.plant_id = s.plant_id;

## use COUNT() to get plants that we have seeds for AND are in garden_bed - how many are in BOTH places
select count(p.plant_name)
from plant p
	inner join seeds s
		on p.plant_id = s.plant_id
	inner join garden_bed gb
		on s.plant_id = gb.plant_id; 