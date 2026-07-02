#!/usr/bin/env python
# -*- coding: utf-8 -*-

import re
import argparse
import codecs

def to_unicode(s):
    """Возвращает юникод-строку для Python 2 и 3"""
    if isinstance(s, bytes):
        return s.decode('utf-8')
    return s

class Re(object):
    def __init__(self):
        self.last_match = None
    def match(self, pattern, text):
        self.last_match = re.match(pattern, text)
        return self.last_match
    def search(self, pattern, text):
        self.last_match = re.search(pattern, text)
        return self.last_match

parser = argparse.ArgumentParser(description='YAmoney parser.')
parser.add_argument('--yampayment_txt', type=str, help='in: yampayment saved e-mail')
parser.add_argument('--yampayment_csv', type=str, help='out:yampayment csv file')
parser.add_argument('--yam_item_csv', type=str, help='out: yam_item csv file')
# parser.add_argument('--log', type=str, default="DEBUG", help='log level')
args = parser.parse_args()

gre = Re()

yamreg = open(args.yampayment_txt, 'r').readlines()
f_payment = codecs.open(args.yampayment_csv, 'w', 'utf-8')
f_item = codecs.open(args.yam_item_csv, 'w', 'utf-8')

payment = []
items = []
for line in yamreg:
    if gre.match(r'Извещение № (.*)$', line):
        payment.append(gre.last_match.group(1))
    elif gre.match(r'Время платежа: (.*)$', line):
        payment.append(gre.last_match.group(1))
    elif gre.match(r'Сумма: (.*) RUB$', line):
        payment.append(gre.last_match.group(1))
    elif gre.match(r'Номер транзакции: (.*)$', line):
        tran_num = gre.last_match.group(1)
        payment.append(gre.last_match.group(1))
    elif gre.match(r'Идентификатор клиента: (.*)$', line):
        payment.append(gre.last_match.group(1))
    elif gre.match(r'Номер в магазине: (.*)$', line):
        payment.append(gre.last_match.group(1))
    elif gre.match(r'(.*) (.*)\*(.*) руб\.', line):
        # items.append(u"{0}^{1}^{2}^{3}".format(tran_num, gre.last_match.group(1).decode('utf-8').strip().replace('\\"', '""""'),
        items.append(u"{0}^{1}^{2}^{3}".format(tran_num, to_unicode(gre.last_match.group(1)).strip().replace('\\"', '""""'),
                                                 to_unicode(gre.last_match.group(2)).strip(), # шт
                                                 to_unicode(gre.last_match.group(3)).strip()) ) # руб
    else:
        # do something else
        # print line
        pass

str_payment = u"^".join(payment) + "\n"
f_payment.write(str_payment)
f_payment.close()
#print "payment"
#print str_payment
str_items = u"\n".join(items) + "\n"
#print "Items"
#print str_items
f_item.write(str_items)
f_item.close()
