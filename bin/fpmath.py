#!/usr/bin/env python3

from ctypes import *
import argparse
import re

defaults = {}
defaults["num"] = '0x00000000'
defaults["file"] = 'run.log'

parser = argparse.ArgumentParser(description='Floating point number analyzer')
parser.add_argument("--file", dest="file", default=defaults["file"],
                    help="log file for analysis")
parser.add_argument("--num", dest="num", default=defaults["num"],
                    help="fp number of bits for analysis")
parser.add_argument("-d", "--diff", dest="diff", action="store_true",
                    help="comparing two numbers")
parser.add_argument("--fp16", dest="fp16", action="store_true",
                    help="use fp16 format")
parser.add_argument("args", nargs="*", help="numbers to analyze")

options = parser.parse_args()
args = options.args

class colors:
    HEADER = '\033[94m'
    YELLOW = '\033[93m'
    WARN = '\033[95m'
    PASS = '\033[92m'
    FAIL = '\033[91m'
    BLINK = '\033[5m'
    ENDC = '\033[0m'
    BOLD = '\033[1m'
    UNDERLINE = '\033[4m'

class ufloat:
    def half2bits(self, num):
        sign = (num&0x8000) >> 15
        exp  = (num&0x7c00) >> 10
        mant = (num&0x3ff) << 13
        bits = (sign << 31) | (exp-15+127 << 23) | (mant)
        return bits
    
    def bits2float(self, num, fp16):
        bits = self.half2bits(num) if fp16 else num
        cp = pointer(c_int(bits))        # make this into a c integer
        fp = cast(cp, POINTER(c_float))  # cast the int pointer to a float pointer
        return fp.contents.value

    def float2bits(self, num):
        flt = num
        cp = pointer(c_float(flt))       # make this into a c float
        it = cast(cp, POINTER(c_int))    # cast the int pointer to an int pointer
        return it.contents.value

    def is_float(self, value):
        try:
            float(value)
            return True
        except (ValueError, TypeError):
            return False

    def set_num_str(self, str, fp16=False):
        if (self.is_float(str)) :
            self.f = float(str)
            self.u = self.float2bits(self.f)
        else :
            self.u = self.half2bits(int(str, 0)) if fp16 else int(str, 0)
            self.f = self.bits2float(int(str, 0), fp16)

        self.u16 = (self.sign() << 15) | (self.exp(5) << 10) | ((self.mant() & 0x7fffff) >> 13)
        self.f16 = self.bits2float(self.u16, True)

    def sign(self):
        return (self.u >> 31) & 0x1

    def sign_str(self):
        if (self.sign() == 1) :
            return "-"
        else :
            return "+"

    def mant10(self):
        hidden_one = (1 << 10)
        return (self.u16 & 0x3FF) | hidden_one

    def mant23(self):
        hidden_one = (1 << 23)
        return (self.u & 0x7fffff) | hidden_one

    def mant(self, mant10=False):
        if (mant10) :
            return self.mant10()
        else :
            return self.mant23()

    def exp(self, bits=8):
        exp_biased = (self.u >> 23) & 0xff
        exp_convert = self.exp_convert(exp_biased, 8, bits)
        return exp_convert

    def exp_convert(self, exp, bits_in, bits_out):
        bias_in  = (2**bits_in)//2 - 1
        bias_out = (2**bits_out)//2 - 1
        sat_out  = (2**bits_out) - 1

        tmp = exp - bias_in + bias_out
        if (tmp == 0) :
            return 0
        elif (tmp < 0) :
            return 0
        elif (tmp > sat_out) :
            return sat_out
        return tmp

    def exp_nobias(self, bits):
        exp  = self.exp(bits)
        bias = (2**bits)//2 - 1
        return exp - bias

def count_diff(lhs, rhs):
    output = 0
    for idx in range(len(lhs)):
        if (lhs[idx] != rhs[idx]):
            output = output +1
    return output

def show_diff(lhs, rhs, fmt):
    output = []
    for idx in range(len(lhs)):
        if (lhs[idx] == rhs[idx]):
            output.append(lhs[idx])
        else:
            output.append(fmt + lhs[idx] + colors.ENDC)
    return ''.join(output)

def main():
    if (options.diff or len(args) == 2) :
        # Auto-detect fp16 format from first argument
        if re.match(r"0[xX][0-9a-fA-F]{4}$", args[0]):
            options.fp16 = True

        num1 = ufloat()
        num1.set_num_str(args[0], options.fp16)
        num2 = ufloat()
        num2.set_num_str(args[1], options.fp16)

        summary = ""
        if (num1.exp() != num2.exp()):
            summary +="----------------------------------------------------------\n"
            summary += colors.FAIL + "Exp diff by %d\n" % (num2.exp() - num1.exp()) + colors.ENDC
            summary += "lhs = 0x%02x\nrhs = 0x%02x\n" % (num1.exp(), num2.exp())
        if (num1.mant(options.fp16) != num2.mant(options.fp16)):
            summary +="----------------------------------------------------------\n"
            lhs = format(num1.mant(options.fp16),'#025b')
            rhs = format(num2.mant(options.fp16),'#025b')
            summary += colors.FAIL + "Mant diff by %d bits\n" % count_diff(lhs, rhs) + colors.ENDC
            lhs_c = show_diff(lhs, rhs, colors.FAIL)
            rhs_c = show_diff(rhs, lhs, colors.FAIL + colors.UNDERLINE)
            summary += "lhs = %s\nrhs = %s\n" % (lhs_c, rhs_c)
        if (summary == ""):
            summary += colors.PASS + "[Success] Numbers are matching 100%" + colors.ENDC

        print(summary)
    elif (options.num or len(args) == 1) :
        if (len(args) == 1) :
            arg = args[0]
        else :
            arg = options.num

        if re.match(r"0[xX][0-9a-fA-F]{4}$", arg):
            options.fp16 = True

        num = ufloat()
        num.set_num_str(arg, options.fp16)

        print(colors.PASS + "----------------------------------------------------------")
        print( "float32 = %.8f \t (0x%08x)" % (num.f, num.u) )
        print( "exp8b   = %d \t\t (%03d 0x%02x)" % (num.exp_nobias(8), num.exp(8), num.exp(8)) )
        print( "man23b  = 0x%06x \t (%s)" % (num.mant(False), bin(num.mant(False))) )
        print( "sign    = %d" % num.sign() )
        print( "        = %s1.%s x 2^%d" % (num.sign_str(), bin(num.mant23())[2:], num.exp_nobias(8)) )
        print(colors.PASS + "----------------------------------------------------------")
        print( "float16 = %.8f \t (0x%04x)" % (num.f16, num.u16) )
        print( "exp5b   = %d \t\t (%02d 0x%02x)" % (num.exp_nobias(5), num.exp(5), num.exp(5)) )
        print( "man10b  = 0x%03x \t (%s)" % (num.mant(True), bin(num.mant(True))) )
        print( "sign    = %d" % num.sign() )
        print( "        = %s1.%s x 2^%d" % (num.sign_str(), bin(num.mant10())[2:], num.exp_nobias(5)) )
        print(colors.PASS + "----------------------------------------------------------")
    else :
        parser.print_help()

if __name__ == '__main__':
    main()
