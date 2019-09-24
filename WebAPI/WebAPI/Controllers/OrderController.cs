using System;
using System.Collections.Generic;
using System.Data;
using System.Data.Entity;
using System.Data.Entity.Infrastructure;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;
using System.Web.Http.Description;
using WebAPI.Models;

namespace WebAPI.Controllers
{
    public class OrderController : ApiController
    {
        private DBModel db = new DBModel();

        // GET: api/Order
        public System.Object GetOrder()
        {
            var result = (from a in db.Order
                          join b in db.Customer on a.CustomerID equals b.CustomerID

                          select new
                          {
                              a.OrderID,
                              a.OrderNo,
                              Customer = b.Name,
                              a.OrderAmount,
                              a.OrderItems,
                              a.OrderStatus
                          }).ToList();
            return result;
        }

        // GET: api/Order/5
        [ResponseType(typeof(Order))]
        public IHttpActionResult GetOrder(long id)
        {
            var order = (from a in db.Order
                         where a.OrderID == id

                         select new
                         {
                             a.OrderID,
                             a.OrderNo,
                             a.CustomerID,
                             a.Date,
                             a.OrderAmount,
                             a.OrderStatus,
                             DeleteOrderItemIDs =""
                         }).FirstOrDefault();
            var orderDetails = (from a in db.OrderItems
                                join b in db.Item on a.itemID equals b.itemID
                                where a.OrderID == id

                                select new
                                {
                                    a.OrderID,
                                    a.OrderItemID,
                                    a.itemID,
                                    ItemMake = b.Make,
                                    b.Model,
                                    b.Year,
                                    b.VIN,
                                    a.Quantity
                                }).ToList();
            return Ok(new { order, orderDetails });
        }

        

        // POST: api/Order
        [ResponseType(typeof(Order))]
        public IHttpActionResult PostOrder(Order order)
        {
            try
            {
                //Order table
                if (order.OrderID == 0)
                    db.Order.Add(order);
                else
                    db.Entry(order).State = EntityState.Modified;

                //OrderItems table
                foreach (var item in order.OrderItems)
                {
                    if (item.OrderItemID == 0)
                        db.OrderItems.Add(item);
                    else
                        db.Entry(item).State = EntityState.Modified;
                }

                //Delete for OrderItems
                foreach (var id in order.DeleteOrderItemIDs.Split(',').Where(x => x != ""))
                {
                    OrderItems x = db.OrderItems.Find(Convert.ToInt64(id));
                    db.OrderItems.Remove(x);
                }


                db.SaveChanges();

                return Ok();
            }
            catch (Exception ex)
            {

                throw ex;
            }

        }

        // DELETE: api/Order/5
        [ResponseType(typeof(Order))]
        public IHttpActionResult DeleteOrder(long id)
        {
            Order order = db.Order.Include(y => y.OrderItems)
                .SingleOrDefault(x => x.OrderID == id);
         
            foreach ( var item in order.OrderItems.ToList())
            {
                db.OrderItems.Remove(item);
            }
            db.Order.Remove(order);
            db.SaveChanges();

            return Ok(order);
        }

        protected override void Dispose(bool disposing)
        {
            if (disposing)
            {
                db.Dispose();
            }
            base.Dispose(disposing);
        }

        private bool OrderExists(long id)
        {
            return db.Order.Count(e => e.OrderID == id) > 0;
        }
    }
}