----Q1:

select customer.first_name, customer.last_name, artist.name,
invoice.total from customer
join invoice on customer.customer_id = invoice.customer_id
join invoice_line on invoice.invoice_id = invoice_line.invoice_id
join track on invoice_line.track_id = track.track_id
join album on track.album_id = album.album_id
join artist on album.artist_id = artist.artist_id
group by customer.first_name, customer.last_name, artist.name,
invoice.total
order by invoice.total desc
---(WRONG)

with best_selling_artist as (
   select artist.artist_id as artist_id, artist.name as artist_name, 
   sum(invoice_line.unit_price*invoice_line.quantity) as total_sales from invoice_line
   join track on track.track_id = invoice_line.track_id
   join album on album.album_id = track.album_id
   join artist on artist.artist_id = album.artist_id
   group by 1
   order by 3 desc
   limit 1
)

select c.customer_id,c.first_name,c.last_name, bsa.artist_name,
sum(il.unit_price*il.quantity) as amount_spent from invoice as i
 join customer as c on c.customer_id = i.customer_id
 join invoice_line as il on il.invoice_id = i.invoice_id
 join track as t on t.track_id = il.track_id
 join album as alb on alb.album_id = t.album_id
 join best_selling_artist as bsa on bsa.artist_id = alb.artist_id
 group by 1,2,3,4
 order by 5 desc

 ----Q2:

with popular_genre as (
select count(invoice_line.quantity) as purchases, customer.country, genre.name, genre.genre_id,
row_number( ) over(partition by customer.country order by count(invoice_line.quantity)desc)as row_no 
from invoice_line
join invoice on invoice.invoice_id = invoice_line.invoice_id
join customer on customer.customer_id = invoice.customer_id
join track on track.track_id = invoice_line.track_id
join genre on genre.genre_id = track.genre_id
group by 2,3,4
order by 2 asc, 1 desc )
select * from popular_genre where row_no <=1

 
----Q3:

with customer_with_country as(
select customer.customer_id,first_name,last_name,billing_country,
sum(total) as total_spending, row_number( ) over(
partition by billing_country order by sum(total) desc) as row_no from invoice
join customer on customer.customer_id = invoice.customer_id
group by 1,2,3,4
order by 4 asc, 5 desc
)
select * from customer_with_country where row_no <=1 
order by total_spending desc









