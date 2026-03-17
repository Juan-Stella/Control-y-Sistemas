import tkinter as tk
from tkinter import ttk
import struct
import re
from decimal import Decimal, getcontext

class FloatConverterApp(tk.Tk):
    def __init__(self):
        super().__init__()
        self.title("Conversor de Punto Flotante IEEE-754 (32 bits)")
        
        # Color Palette
        self.bg_main = "#f0f4f8"  # Soft slate/blueish background
        self.bg_card = "#ffffff"  # White for cards
        self.text_main = "#1e293b" # Dark Slate
        self.accent_color = "#3b82f6" # Tailwind Blue
        self.accent_light = "#eff6ff"
        self.border_color = "#cbd5e1"
        self.success_color = "#10b981"
        self.error_color = "#ef4444"
        
        self.font_main = ("Segoe UI", 11)
        self.font_title = ("Segoe UI Semibold", 13)
        self.font_mono = ("Consolas", 11)
        self.font_mono_bold = ("Consolas", 12, "bold")
        
        self.configure(bg=self.bg_main)
        self.geometry("950x620")
        self.resizable(False, False)
        
        # Application Styles
        self.style = ttk.Style()
        if 'clam' in self.style.theme_names():
            self.style.theme_use('clam')
            
        self.style.configure('TNotebook', background=self.bg_main, borderwidth=0)
        self.style.configure('TNotebook.Tab', font=("Segoe UI Semibold", 11), padding=[15, 8], background="#e2e8f0", foreground=self.text_main)
        self.style.map('TNotebook.Tab', background=[('selected', self.bg_card)], foreground=[('selected', self.accent_color)])
        self.style.configure('TFrame', background=self.bg_main)
        self.style.configure('Card.TFrame', background=self.bg_card, relief="flat")
        self.style.configure('Accent.TButton', font=("Segoe UI Semibold", 11), background=self.accent_color, foreground="white", padding=[10, 5])
        
        self.notebook = ttk.Notebook(self)
        self.notebook.pack(fill='both', expand=True, padx=15, pady=15)
        
        self.format_mode = tk.StringVar(value="auto") # "auto" or "fixed"
        
        self.build_converter_tab()
        self.build_calculator_tab()

    def parse_math_input(self, val_str):
        # Allow safe math evaluation: e.g. "3*10^-3" -> "3*10**-3"
        val_str = val_str.strip().lower()
        if not val_str:
            return None
            
        if val_str in ("-", "."):
            return None
            
        if val_str in ("nan", "inf", "-inf", "infinity", "-infinity"):
            return float(val_str)
            
        # Fix commas as dots
        val_str = val_str.replace(',', '.')
        
        # Fix math notation
        val_str = val_str.replace('x', '*')  # user typing 3 x 10^-3
        val_str = val_str.replace('^', '**') # user typing 3 * 10^-3
        
        # Fix confusing 10e-3 meaning 10^-3 (instead of 10 * 10^-3)
        # e.g., "3 * 10e-3" -> "3 * 10**-3"
        val_str = re.sub(r'10\s*e\s*([+-]?\d+)', r'10**\1', val_str)
        # Handle standalone "e-3" meaning "10**-3" only if strictly needed, but let's stick to standard py e format otherwise.
        # But wait, python natively treats '3e-3' as 3 * 10^-3.
        # We only need to fix explicit "10e-X" or "^" syntax.
        
        try:
            # Safe evaluation without builtins to prevent arbitrary code execution
            code = compile(val_str, "<string>", "eval")
            for name in code.co_names:
                raise NameError(f"Names not allowed in math parsing: {name}")
                
            return float(eval(code, {"__builtins__": {}}, {}))
        except Exception:
            raise ValueError("Invalid Math Expression")

    def create_card_frame(self, parent):
        f = tk.Frame(parent, bg=self.bg_card, highlightbackground=self.border_color, highlightthickness=1, bd=0)
        return f

    def build_converter_tab(self):
        self.conv_tab = tk.Frame(self.notebook, bg=self.bg_main)
        self.notebook.add(self.conv_tab, text="🔍 Convertidor interactivo")
        
        # --- Top Input Section ---
        top_card = self.create_card_frame(self.conv_tab)
        top_card.pack(fill="x", padx=10, pady=(10, 5))
        
        lbl = tk.Label(top_card, text="Valor Numérico/Expresión:", font=self.font_title, bg=self.bg_card, fg=self.text_main)
        lbl.pack(side="left", padx=(15, 10), pady=15)
        
        border_frame = tk.Frame(top_card, bg=self.accent_color, padx=2, pady=2)
        border_frame.pack(side="left", pady=15)
        
        self.entry_var = tk.StringVar()
        self.entry_var.trace_add("write", self.on_input_change)
        self.decimal_entry = tk.Entry(border_frame, textvariable=self.entry_var, font=self.font_main, width=30, relief="flat", bg="#fafafa")
        self.decimal_entry.pack(padx=1, pady=1, ipady=4)
        
        tk.Label(top_card, text="Ej: 6430.04 | 3.4e-10 | 3*10^-3", font=("Segoe UI", 9, "italic"), bg=self.bg_card, fg="#64748b").pack(side="left", padx=10)
        
        # Format modes
        fmt_frame = tk.Frame(top_card, bg=self.bg_card)
        fmt_frame.pack(side="right", padx=15)
        tk.Label(fmt_frame, text="Ver Decimál:", bg=self.bg_card, font=("Segoe UI Semibold", 10), fg=self.text_main).pack(side="left", padx=5)
        ttk.Radiobutton(fmt_frame, text="Sci (3.4e-10)", variable=self.format_mode, value="auto", command=self.on_input_change).pack(side="left", padx=2)
        ttk.Radiobutton(fmt_frame, text="Fixed (0.00...)", variable=self.format_mode, value="fixed", command=self.on_input_change).pack(side="left", padx=2)
        
        # --- Titles ---
        header_frame = tk.Frame(self.conv_tab, bg=self.bg_main)
        header_frame.pack(fill="x", padx=10, pady=(10, 5))
        
        tk.Label(header_frame, text="Representación Precisión Simple IEEE-754 (32 bits)", font=("Segoe UI", 12, "bold"), bg=self.bg_main, fg=self.text_main).pack(side="left")
        
        self.status_var = tk.StringVar(value="")
        status_lbl = tk.Label(header_frame, textvariable=self.status_var, font=("Segoe UI Semibold", 11), bg=self.bg_main, fg=self.accent_color)
        status_lbl.pack(side="right", padx=10)
        
        # --- Memory Map ---
        main_card = self.create_card_frame(self.conv_tab)
        main_card.pack(fill="x", padx=10, pady=5)
        main_card.grid_columnconfigure(0, weight=1)
        main_card.grid_columnconfigure(1, weight=3)
        main_card.grid_columnconfigure(2, weight=4)
        
        lbl_bg = "#f8fafc"
        base_h = 35
        
        # Column 0: Sign
        col0 = tk.Frame(main_card, bg=lbl_bg, highlightbackground=self.border_color, highlightthickness=1)
        col0.grid(row=0, column=0, sticky="nsew")
        tk.Label(col0, text="Bit 31", font=("Segoe UI Semibold", 10), bg=lbl_bg, fg="#64748b").pack(pady=(10,0))
        tk.Label(col0, text="Sing Bit", font=self.font_main, bg=lbl_bg, fg=self.text_main).pack()
        
        self.sign_var = tk.StringVar()
        tk.Entry(col0, textvariable=self.sign_var, state="readonly", width=3, justify="center", font=self.font_mono_bold, bg="white", relief="solid", bd=1).pack(pady=10, ipady=2)
        tk.Label(col0, text="0: +\n1: -", font=self.font_mono, bg=lbl_bg, fg="#64748b").pack(pady=(0,10))
        
        # Column 1: Exponent
        col1 = tk.Frame(main_card, bg=lbl_bg, highlightbackground=self.border_color, highlightthickness=1)
        col1.grid(row=0, column=1, sticky="nsew", padx=(0,0))
        tk.Label(col1, text="Bits 30 - 23", font=("Segoe UI Semibold", 10), bg=lbl_bg, fg="#64748b").pack(pady=(10,0))
        tk.Label(col1, text="Exponent Field", font=self.font_main, bg=lbl_bg, fg=self.text_main).pack()
        
        self.exp_bin_var = tk.StringVar()
        tk.Entry(col1, textvariable=self.exp_bin_var, state="readonly", width=12, justify="center", font=self.font_mono_bold, bg="white", fg=self.accent_color, relief="solid", bd=1).pack(pady=10, ipady=2)
        
        tk.Label(col1, text="Valor del Exponente (Exp - Sesgo):", font=("Segoe UI Semibold", 9), bg=lbl_bg, fg="#475569").pack()
        calc_f = tk.Frame(col1, bg=lbl_bg)
        calc_f.pack(pady=(5,15))
        self.exp_raw_var = tk.StringVar()
        self.exp_actual_var = tk.StringVar()
        tk.Entry(calc_f, textvariable=self.exp_raw_var, state="readonly", width=5, justify="center", font=self.font_mono, bg="white").pack(side="left")
        tk.Label(calc_f, text=" - 127 = ", font=self.font_mono, bg=lbl_bg).pack(side="left")
        tk.Entry(calc_f, textvariable=self.exp_actual_var, state="readonly", width=5, justify="center", font=self.font_mono, bg="white", fg="#10b981").pack(side="left")

        # Column 2: Significand
        col2 = tk.Frame(main_card, bg=lbl_bg, highlightbackground=self.border_color, highlightthickness=1)
        col2.grid(row=0, column=2, sticky="nsew")
        tk.Label(col2, text="Bits 22 - 0", font=("Segoe UI Semibold", 10), bg=lbl_bg, fg="#64748b").pack(pady=(10,0))
        tk.Label(col2, text="Significand / Fraction", font=self.font_main, bg=lbl_bg, fg=self.text_main).pack()
        
        self.sig_bin_var = tk.StringVar()
        tk.Entry(col2, textvariable=self.sig_bin_var, state="readonly", width=32, justify="left", font=self.font_mono_bold, bg="white", fg="#eab308", relief="solid", bd=1).pack(pady=10, ipady=2)
        
        tk.Label(col2, text="Valor Real de la Fracción:", font=("Segoe UI Semibold", 9), bg=lbl_bg, fg="#475569").pack()
        self.sig_dec_var = tk.StringVar()
        tk.Entry(col2, textvariable=self.sig_dec_var, state="readonly", width=25, justify="center", font=self.font_mono, bg="white").pack(pady=(5,15))
        
        # --- Bottom Result Section ---
        bot_card = self.create_card_frame(self.conv_tab)
        bot_card.pack(fill="x", padx=10, pady=10)
        
        tk.Label(bot_card, text="Hexadecimal Compilado:", font=("Segoe UI Semibold", 11), bg=self.bg_card).pack(side="left", padx=(15, 5), pady=15)
        self.hex_var = tk.StringVar()
        tk.Entry(bot_card, textvariable=self.hex_var, state="readonly", width=12, font=self.font_mono_bold, bg="#f8fafc", justify="center", relief="solid", bd=1).pack(side="left", padx=5, ipady=3)
        
        tk.Label(bot_card, text="Decimal Recuperado de Memoria:", font=("Segoe UI Semibold", 11), bg=self.bg_card).pack(side="left", padx=(25, 5), pady=15)
        self.dec_out_var = tk.StringVar()
        tk.Entry(bot_card, textvariable=self.dec_out_var, state="readonly", font=self.font_mono_bold, bg=self.accent_light, fg=self.accent_color, relief="solid", bd=1, highlightbackground=self.accent_color, highlightthickness=1).pack(side="left", fill="x", expand=True, padx=(5, 15), ipady=3)

    def build_calculator_tab(self):
        self.calc_tab = tk.Frame(self.notebook, bg=self.bg_main)
        self.notebook.add(self.calc_tab, text="🔢 Calculadora")
        
        header_card = self.create_card_frame(self.calc_tab)
        header_card.pack(fill="x", padx=10, pady=10)
        tk.Label(header_card, text="Operaciones Simples evidenciando Fallos de Precisión", font=self.font_title, bg=self.bg_card, fg=self.text_main).pack(pady=12)
        
        inp_card = self.create_card_frame(self.calc_tab)
        inp_card.pack(padx=10, pady=5)
        
        f_in = tk.Frame(inp_card, bg=self.bg_card)
        f_in.pack(padx=15, pady=15)
        
        self.calc_a_var = tk.StringVar()
        self.calc_b_var = tk.StringVar()
        self.op_var = tk.StringVar(value="+")
        
        tk.Label(f_in, text="Operando A", font=self.font_main, bg=self.bg_card).grid(row=0, column=0, pady=(0,5))
        tk.Entry(f_in, textvariable=self.calc_a_var, font=self.font_main, width=18, relief="solid", bd=1).grid(row=1, column=0, padx=10, ipady=4)
        
        tk.Label(f_in, text="Op", font=self.font_main, bg=self.bg_card).grid(row=0, column=1, pady=(0,5))
        ttk.Combobox(f_in, textvariable=self.op_var, values=["+", "-", "*", "/"], width=4, state="readonly", font=self.font_main).grid(row=1, column=1, padx=10, ipady=2)
        
        tk.Label(f_in, text="Operando B", font=self.font_main, bg=self.bg_card).grid(row=0, column=2, pady=(0,5))
        tk.Entry(f_in, textvariable=self.calc_b_var, font=self.font_main, width=18, relief="solid", bd=1).grid(row=1, column=2, padx=10, ipady=4)
        
        calc_btn = tk.Button(f_in, text="Calcular", font=("Segoe UI Semibold", 11), bg=self.success_color, fg="white", activebackground="#059669", activeforeground="white", relief="flat", cursor="hand2", command=self.do_calculation)
        calc_btn.grid(row=1, column=3, padx=15, ipady=2, ipadx=10)
        
        # Formats
        tk.Label(f_in, text="Los operandos también soportan Math strings (ej: 0.1, 3*10^-3)", font=("Segoe UI", 9, "italic"), bg=self.bg_card, fg="#64748b").grid(row=2, column=0, columnspan=4, pady=(10,0))
        
        res_card = self.create_card_frame(self.calc_tab)
        res_card.pack(fill="both", expand=True, padx=10, pady=10)
        
        tk.Label(res_card, text="📊 Análisis de Memoria al Operar", font=("Segoe UI Semibold", 12), bg=self.bg_card).pack(anchor="w", padx=15, pady=(15, 5))
        
        grid_f = tk.Frame(res_card, bg=self.bg_card)
        grid_f.pack(fill="both", expand=True, padx=15, pady=5)
        
        labels = [
            ("Matemática Ideal (Infinita):", "#10b981"),
            ("Valor Guardado Realmente (32 bits):", self.accent_color),
            ("Memoria Binaria de ese Resultado:", "#eab308")
        ]
        
        self.res_ideal_var = tk.StringVar()
        self.res_float_var = tk.StringVar()
        self.res_bin_var = tk.StringVar()
        vars = [self.res_ideal_var, self.res_float_var, self.res_bin_var]
        
        for i, (text, color) in enumerate(labels):
            tk.Label(grid_f, text=text, font=("Segoe UI Semibold", 11), bg=self.bg_card, fg=self.text_main).grid(row=i, column=0, sticky="w", pady=10)
            tk.Entry(grid_f, textvariable=vars[i], state="readonly", width=55, font=self.font_mono_bold, bg="#f8fafc", fg=color, relief="solid", bd=1).grid(row=i, column=1, sticky="we", padx=(10,0), ipady=4)
            
        grid_f.grid_columnconfigure(1, weight=1)

    def format_number(self, val):
        if self.format_mode.get() == "auto":
            return str(val)
        else:
            str_val = f"{val:.50f}"
            if '.' in str_val:
                str_val = str_val.rstrip('0').rstrip('.')
            if str_val == "": str_val = "0"
            return str_val

    def on_input_change(self, *args):
        val_str = self.entry_var.get()
        try:
            val = self.parse_math_input(val_str)
            if val is None:
                self.clear_fields()
                return
        except ValueError:
            self.clear_fields()
            self.status_var.set("Sintaxis Inválida")
            return

        try:
            packed = struct.pack('>f', val)
            bits = struct.unpack('>I', packed)[0]
        except OverflowError:
            self.clear_fields()
            self.status_var.set("Overflow (Fuera de Rango)")
            return

        sign_bit = (bits >> 31) & 1
        exponent = (bits >> 23) & 0xFF
        fraction = bits & 0x7FFFFF

        self.sign_var.set(str(sign_bit))
        self.exp_bin_var.set(f"{exponent:08b}")
        
        if exponent == 255:
            if fraction == 0:
                status = "✨ Infinito"
                self.sig_bin_var.set(f"1.{fraction:023b}")
                self.sig_dec_var.set("inf")
                self.exp_raw_var.set("255")
                self.exp_actual_var.set("N/A")
            else:
                status = "🛑 NaN (Not a Number)"
                self.sig_bin_var.set(f"1.{fraction:023b}")
                self.sig_dec_var.set("NaN")
                self.exp_raw_var.set("255")
                self.exp_actual_var.set("N/A")
        elif exponent == 0:
            if fraction == 0:
                status = "⭕ Cero"
                self.sig_bin_var.set(f"0.{fraction:023b}")
                self.sig_dec_var.set("0.0")
                self.exp_raw_var.set("0")
                self.exp_actual_var.set("-127")
            else:
                status = "📉 Subnormal (Muy Pequeño)"
                self.sig_bin_var.set(f"0.{fraction:023b}")
                sig_val = fraction / (2**23)
                self.sig_dec_var.set(f"{sig_val:.7f}")
                self.exp_raw_var.set("0")
                self.exp_actual_var.set("-126")
        else:
            status = "✅ Normalizado"
            self.sig_bin_var.set(f"1.{fraction:023b}")
            sig_val = 1.0 + (fraction / (2**23))
            self.sig_dec_var.set(f"{sig_val:.7f}")
            self.exp_raw_var.set(str(exponent))
            self.exp_actual_var.set(str(exponent - 127))

        self.status_var.set(status)
        self.hex_var.set(f"0x{bits:08X}")
        
        val_unpacked = struct.unpack('>f', packed)[0]
        if "NaN" in status or "Infinito" in status or "Cero" in status:
            self.dec_out_var.set(str(val_unpacked))
        else:
            self.dec_out_var.set(self.format_number(val_unpacked))

    def clear_fields(self):
        self.status_var.set("")
        self.sign_var.set("")
        self.exp_bin_var.set("")
        self.exp_raw_var.set("")
        self.exp_actual_var.set("")
        self.sig_bin_var.set("")
        self.sig_dec_var.set("")
        self.hex_var.set("")
        self.dec_out_var.set("")

    def do_calculation(self):
        a_str = self.calc_a_var.get()
        b_str = self.calc_b_var.get()
        op = self.op_var.get()
        
        try:
            val_a = self.parse_math_input(a_str)
            val_b = self.parse_math_input(b_str)
            if val_a is None or val_b is None:
                raise ValueError
        except ValueError:
            self.res_ideal_var.set("Error: Parseo de expresión fallido.")
            self.res_float_var.set("")
            self.res_bin_var.set("")
            return
            
        getcontext().prec = 50
        
        try:
            if op == "+":
                res_float = val_a + val_b
                res_dec = Decimal(str(val_a)) + Decimal(str(val_b))
            elif op == "-":
                res_float = val_a - val_b
                res_dec = Decimal(str(val_a)) - Decimal(str(val_b))
            elif op == "*":
                res_float = val_a * val_b
                res_dec = Decimal(str(val_a)) * Decimal(str(val_b))
            elif op == "/":
                if val_b == 0:
                    raise ZeroDivisionError
                res_float = val_a / val_b
                res_dec = Decimal(str(val_a)) / Decimal(str(val_b))
                
            self.res_ideal_var.set(str(res_dec))
            
            packed = struct.pack('>f', res_float)
            res_float_packed = struct.unpack('>f', packed)[0]
            bits = struct.unpack('>I', packed)[0]
            
            # Show the fully expanded string to show floating point noise prominently if it exists
            s_val = f"{res_float_packed:.50f}".rstrip('0').rstrip('.') if '.' in f"{res_float_packed:.50f}" else f"{res_float_packed:.0f}"
            self.res_float_var.set(s_val or "0")
            
            s = (bits >> 31) & 1
            e = (bits >> 23) & 0xFF
            f = bits & 0x7FFFFF
            self.res_bin_var.set(f"{s} | {e:08b} | {f:023b}")
            
        except ZeroDivisionError:
            self.res_ideal_var.set("Error: División por Cero")
            self.res_float_var.set("")
            self.res_bin_var.set("")
        except Exception as e:
            self.res_ideal_var.set(f"Error: {str(e)}")
            self.res_float_var.set("")
            self.res_bin_var.set("")

if __name__ == "__main__":
    app = FloatConverterApp()
    app.mainloop()
