import { Component, OnInit, Inject } from '@angular/core';
import { MAT_DIALOG_DATA, MatDialogRef } from '@angular/material';
import { ItemService } from 'src/app/shared/item.service';
import { OrderService } from 'src/app/shared/order.service';
import { OrderItem } from 'src/app/shared/order-item.model';
import { Item } from 'src/app/shared/item.model';
import { NgForm } from '@angular/forms';

@Component({
  selector: 'app-order-items',
  templateUrl: './order-items.component.html',
  styleUrls: ['./order-items.component.css']
})
export class OrderItemsComponent implements OnInit {
  formData: OrderItem;
  itemList: Item[];
  isValid: boolean = true;

  constructor(
    @Inject(MAT_DIALOG_DATA) public data,
    public dialogRef: MatDialogRef<OrderItemsComponent>,
    private itemService: ItemService,
    private orderService: OrderService) { }

  ngOnInit() {
    this.itemService.getItemList().then(res => this.itemList = res as Item[]);
    if (this.data.OrderItemIndex == null)
      this.formData = {
        OrderItemID: null,
        OrderID: this.data.OrderID,
        itemID: 0,
        Quantity: 0,
        Make: '',
        Model: '',
        Year: 0,
        VIN: ''
      }
      else 
      this.formData = Object.assign({}, this.orderService.orderItems[this.data.orderItemIndex]);
  }

  updateInfo(ctrl) {
    if (ctrl.selectedIndex == 0) {
      this.formData.Make = '';
      this.formData.Year = 0;
      this.formData.VIN = '';
    }
    else {
      this.formData.Make = this.itemList[ctrl.selectedIndex - 1].Make;
      this.formData.Year = this.itemList[ctrl.selectedIndex - 1].Year;
      this.formData.VIN = this.itemList[ctrl.selectedIndex - 1].VIN;
    }
  }

  onSubmit(form: NgForm) {
    if(this.validateForm(form.value)){
      if(this.data.orderItemIndex == null)
    this.orderService.orderItems.push(form.value);
    else
    this.orderService.orderItems[this.data.orderItemIndex] = form.value;
    this.dialogRef.close();
    console.log(this.orderService.formData.OrderID);
    }
  }

  validateForm(formData: OrderItem) {
    this.isValid = true;
    if ((formData.Make && formData.Model && formData.VIN) == '')
      this.isValid = false;
    else if ((formData.Quantity && formData.Year) == 0)
      this.isValid = false;
    return this.isValid;
  }
}
