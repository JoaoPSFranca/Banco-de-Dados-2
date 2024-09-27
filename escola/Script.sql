drop schema if exists escola cascade;
create schema escola;
set search_path to escola;

CREATE TABLE curso (
    idCurso SERIAL,
    nome VARCHAR(60) NOT NULL,
    totalHoras INT NOT NULL,
    valor FLOAT NOT NULL,
    PRIMARY KEY (idCurso)
);

CREATE TABLE disciplina (
    idDisciplina SERIAL,
    nome VARCHAR(45) NOT NULL,
    cargaHoraria INT NOT NULL,
    qtdeHoras INT,
    PRIMARY KEY (idDisciplina)
);

CREATE TABLE aluno (
    idAluno SERIAL,
    nome VARCHAR(45) NOT NULL,
    dataNascimento DATE NOT NULL,
    PRIMARY KEY (idAluno)
);

CREATE TABLE caixa (
    idCaixa SERIAL,
    data DATE DEFAULT CURRENT_DATE,
    entrada FLOAT DEFAULT 0,
    saida FLOAT DEFAULT 0,
    saldo FLOAT DEFAULT 0,
    PRIMARY KEY (idCaixa)
);

CREATE TABLE disciplina_curso (
    idCurso INT NOT NULL,
    idDisciplina INT NOT NULL,
    PRIMARY KEY (idCurso, idDisciplina),
    FOREIGN KEY (idCurso) REFERENCES curso (idCurso),
    FOREIGN KEY (idDisciplina) REFERENCES disciplina (idDisciplina)
);

CREATE TABLE turma (
    idTurma SERIAL,
    idCurso INT NOT NULL,
    sala INT NOT NULL,
    horaInicio TIME NOT NULL,
    horaFim TIME,
    totalAluno INT DEFAULT 0,
    PRIMARY KEY (idTurma),
    FOREIGN KEY (idCurso) REFERENCES curso (idCurso)
);

CREATE TABLE matricula (
    idMatricula SERIAL,
    idAluno INT NOT NULL,
    idTurma INT NOT NULL,
    qtdeParcelas INT NOT NULL,
    situacao VARCHAR(10) DEFAULT 'A',
    data DATE NOT NULL,
    PRIMARY KEY (idMatricula),
    FOREIGN KEY (idAluno) REFERENCES aluno (idAluno),
    FOREIGN KEY (idTurma) REFERENCES turma (idTurma)
);

CREATE TABLE despesa_turma (
    idDespesa SERIAL,
    idCaixa INT NOT NULL,
    idTurma INT NOT NULL,
    valor FLOAT NOT NULL,
    data DATE NOT NULL,
    referente VARCHAR(45),
    PRIMARY KEY (idDespesa),
    FOREIGN KEY (idCaixa) REFERENCES caixa (idCaixa),
    FOREIGN KEY (idTurma) REFERENCES turma (idTurma)
);

CREATE TABLE Notas (
    idNotas      SERIAL,
    idMatricula  INT    NOT NULL,
    idDisciplina INT    NOT NULL,
    nota1        FLOAT DEFAULT 0,
    nota2        FLOAT DEFAULT 0,
    nota3        FLOAT DEFAULT 0,
    nota4        FLOAT DEFAULT 0,
    PRIMARY KEY (idNotas),
    FOREIGN KEY (idMatricula)
        REFERENCES matricula (idMatricula),
    FOREIGN KEY (idDisciplina)
        REFERENCES disciplina (idDisciplina)
);

CREATE TABLE pagamento (
    idPagamento INT NOT NULL,
    idAluno INT NOT NULL,
    idCaixa INT NOT NULL,
    vencimento DATE NOT NULL,
    valor DECIMAL(10,2) DEFAULT 0,
    refMatricula INT,
    status VARCHAR (10) DEFAULT 'Pendente',
    PRIMARY KEY (idPagamento, idAluno),
    FOREIGN KEY (idAluno) REFERENCES aluno (idAluno),
    FOREIGN KEY (idCaixa) REFERENCES caixa (idCaixa)
);
