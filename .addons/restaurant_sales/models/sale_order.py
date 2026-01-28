# -*- coding: utf-8 -*-
from odoo import fields, models


class SaleOrder(models.Model):
    _inherit = "sale.order"

    restaurant_table = fields.Char(string="Restaurant Table")
    order_type = fields.Selection(
        [
            ("dine_in", "Dine In"),
            ("takeaway", "Takeaway"),
            ("delivery", "Delivery"),
        ],
        string="Order Type",
        default="dine_in",
        required=True,
    )
    waiter_name = fields.Char(string="Waiter")
