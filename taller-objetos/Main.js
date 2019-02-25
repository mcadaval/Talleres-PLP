let PolinomioPrototype = {
    grado: function () {
        console.log("Implementacion optimizada");
        return this.gradoMayor();
    },
    toString: function () {
        console.log("Implementacion optimizada");
        return this.sumatoria1.toString() + " + " + this.sumatoria2.toString();
    },
    aPolinomio: function () {
        console.log("Implementacion optimizada");
        return this;
    }
};
Object.setPrototypeOf(PolinomioPrototype, Sumatoria.prototype);

function Monomio(coeficiente, grado) {
    this.coeficiente = coeficiente;
    this.grad = grado;
}

Monomio.prototype.evaluar = function (x) {
    return this.coeficiente * Math.pow(x, this.grad);
};

Monomio.prototype.gradoMayor = function () {
    return this.grad;
};

Monomio.prototype.coefDeGrado = function (g) {
    return g == this.grad ? this.coeficiente : 0;
};

Monomio.prototype.grado = function () {
    return this.coeficiente != 0 ? this.grad : 0;
}

Monomio.prototype.toString = function () {
    let stringMonomio = "";
    if (this.coeficiente != 0)
    {
        if (this.coeficiente == -1)
            stringMonomio += "-";
        else if (this.coeficiente != 1)
            stringMonomio += this.coeficiente;

        if (this.grad == 1)
            stringMonomio += "x";
        else if (this.grad > 1)
            stringMonomio += "x^" + this.grad;
    }
    return stringMonomio;
}

Monomio.prototype.toStringPolinomio = Monomio.prototype.toString;

Monomio.prototype.aPolinomio = function () {
    return this;
}

function Sumatoria(sumatoria1, sumatoria2) {
    this.sumatoria1 = sumatoria1;
    this.sumatoria2 = sumatoria2;
}

Sumatoria.prototype.evaluar = function (x) {
    return this.sumatoria1.evaluar(x) + this.sumatoria2.evaluar(x);
};

Sumatoria.prototype.gradoMayor = function () {
    return Math.max(this.sumatoria1.gradoMayor(), this.sumatoria2.gradoMayor());
};

Sumatoria.prototype.coefDeGrado = function (g) {
    return this.sumatoria1.coefDeGrado(g) + this.sumatoria2.coefDeGrado(g);
};

Sumatoria.prototype.grado = function () {
    let n = this.gradoMayor();
    while (this.coefDeGrado(n) == 0) {
        n--;
    }
    return n;
};

Sumatoria.prototype.toString = function () {
    let grado = this.grado()
    let n = grado;
    let stringSumatoria = "";
    while (n >= 0) {
        let stringMonomio = "";
        let coeficienteDeN = this.coefDeGrado(n);
        if (coeficienteDeN != 0)
            stringMonomio = (new Monomio(coeficienteDeN, n)).toString();

        if (stringMonomio != "" && n != grado)
            stringSumatoria += coeficienteDeN < 0? " " : " + ";

        stringSumatoria += stringMonomio;
        n--;
    }
    return stringSumatoria;
}

Sumatoria.prototype.aPolinomio = function () {
    let grado = this.grado()
    let n = grado;
    let coeficienteDeN = this.coefDeGrado(n);
    let polinomio = new Monomio(coeficienteDeN, n);
    n--;
    while (n >= 0) {
        coeficienteDeN = this.coefDeGrado(n);
        if (coeficienteDeN != 0)
            polinomio = new Sumatoria(polinomio, new Monomio(coeficienteDeN, n));
        n--;
    }
    Object.setPrototypeOf(polinomio, PolinomioPrototype);
    return polinomio;
}

let s1 = new Sumatoria(new Sumatoria(new Monomio(7,2), new Monomio(8,1)), new Sumatoria(new Monomio(-3, 1), new Monomio(4,0)));
let s2 = new Sumatoria(new Monomio(1, 4), new Sumatoria(new Monomio(-1, 4), new Monomio(1, 3)));
let s3 = new Sumatoria(s1, s2);