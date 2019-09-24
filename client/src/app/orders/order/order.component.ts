import { Component, OnInit } from '@angular/core';
import { OrderService } from 'src/app/shared/order.service';
import { NgForm } from '@angular/forms';
import { MatDialogConfig, MatDialog } from '@angular/material';
import { OrderItemsComponent } from '../order-items/order-items.component';
import { Customer } from 'src/app/shared/customer.model';
import { CustomerService } from 'src/app/shared/customer.service';
import { ToastrService } from 'ngx-toastr';
import { Router, ActivatedRoute } from '@angular/router';

@Component({
  selector: 'app-order',
  templateUrl: './order.component.html',
  styleUrls: ['./order.component.css']
})
export class OrderComponent implements OnInit {
  customerList: Customer[];
  isValid: boolean = true;

  constructor(private service: OrderService, private dialog: MatDialog,
    private customerService: CustomerService, private toastr: ToastrService,
    private router: Router, private currentRoute: ActivatedRoute) { }

  ngOnInit() {
    let orderID = this.currentRoute.snapshot.paramMap.get('id');
    if (orderID == null)
      this.resetForm();
    else {
      this.service.getOrderByID(parseInt(orderID)).then(res => {
        this.service.formData = res.order;
        this.service.orderItems = res.orderDetails;
      });
    }
    
    this.customerService.getCustomerList().then(res => this.customerList = res as Customer[]);
  }

  resetForm(form?: NgForm) {
    if (form = null) 
      form.resetForm();
    this.service.formData = {
      OrderID:  Math.floor(100000 + Math.random() * 900000).toString(),
      OrderNo: Math.floor(100000 + Math.random() * 900000).toString(),
      CustomerID: 0,
      Date: '',
      OrderAmount: 0,
      OrderStatus: '',
      DeletedOrderItemIDs: ''
    };
    this.service.orderItems = [];
  }

  AddOrEditOrderItem(orderItemIndex, OrderID) {
    const dialogConfig = new MatDialogConfig();
    dialogConfig.autoFocus = true;
    dialogConfig.disableClose = true;
    dialogConfig.width = "50%";
    dialogConfig.data = { orderItemIndex, OrderID };
    console.log(orderItemIndex, OrderID);
    this.dialog.open(OrderItemsComponent, dialogConfig);
  }

  onDeleteOrderItem(orderItemID: number, i: number) {
    if (orderItemID != null)
      this.service.formData.DeletedOrderItemIDs += orderItemID + ",";
    this.service.orderItems.splice(i, 1);
  }

  validateForm() {
    this.isValid = true;
    if ((this.service.formData.CustomerID && this.service.formData.OrderAmount) == 0){
      this.isValid = false;
    }
    else if ((this.service.formData.Date && this.service.formData.OrderStatus) == '') {
      this.isValid = false;
    }
    else if (this.service.orderItems.length == 0){
      this.isValid = false;
    }
    return this.isValid;
  }

  onSubmit(form: NgForm) {
    if (this.validateForm()) {
      this.service.saveOrUpdateOrder().subscribe(res => {
        this.resetForm();
        this.toastr.success('Submitted Successfully', 'On Service');
        this.router.navigate(['/orders']);
      })
    }
  }
}
