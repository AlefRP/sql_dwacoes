# Data Warehouse para Análise de Ações Financeiras

## Visão Geral

Este Data Warehouse é projetado para armazenar, processar e analisar dados históricos e em tempo real de ações financeiras. Ele permite que analistas e investidores façam consultas complexas, gerem relatórios e obtenham insights para tomar decisões informadas no mercado de ações.

![Nome da imagem](https://raw.githubusercontent.com/AlefRP/sql_dwacoes/main/dw_acoes.svg){: style="border: 5px solid #d2cbf3; border-radius: 20px;"}

## Funcionalidades

- **Armazenamento de Dados**: Estruturação de dados em esquema estrela para otimização de consultas analíticas.
- **Consultas Avançadas**: Capacidade de executar análises profundas com várias dimensões e métricas.
- **Procedimentos Armazenados**: Automatização de tarefas comuns, como a inserção de novos dados de ações.
- **Triggers**: Atualização automática de volumes totais após transações.
- **Views**: Relatórios predefinidos para análises rápidas.

## Estrutura do Banco de Dados

O banco de dados é composto por tabelas de dimensão (`dim_tempo`, `dim_acoes`, `dim_mercado`) e uma tabela de fatos (`fatos_acoes`), seguindo um esquema estrela clássico.

## Como Configurar

1. **Criação do Banco de Dados**: Execute os scripts SQL fornecidos para criar o esquema do banco de dados.
2. **População de Dados**: Use os procedimentos armazenados para inserir dados nas tabelas de dimensão e fatos.
3. **Atualização e Manutenção**: Configure os triggers para manter a integridade e atualização dos dados em tempo real.

## Uso

Para executar consultas e gerar relatórios, utilize as views definidas ou escreva suas próprias consultas SQL. Exemplos de consultas e instruções sobre como usar procedimentos armazenados e triggers estão documentados no diretório `/sql`.

### Executando Procedimentos Armazenados

Para adicionar uma nova ação:

```sql
CALL AdicionarAcao('AAPL', 'Apple Inc.', 'Tecnologia', 'NASDAQ');
```

## Utilizando Views

Para visualizar o relatório de preços das ações:

```sql
SELECT * FROM vw_relatorio_precos_acoes;
```

## Suporte

Se você encontrar algum problema ou tiver alguma dúvida sobre como configurar e usar este Data Warehouse, por favor, abra uma issue no repositório do GitHub. Faremos o possível para ajudar e melhorar a documentação conforme necessário.

## Contribuições

Contribuições para o projeto são muito bem-vindas. Siga os passos abaixo para contribuir:

1. Faça o fork do projeto.
2. Crie uma branch para suas mudanças: `git checkout -b minha-nova-feature`.
3. Faça commit das suas alterações: `git commit -am 'Adiciona alguma feature'`.
4. Faça push para a branch: `git push origin minha-nova-feature`.
5. Envie um pull request.

## Licença

Este projeto é licenciado sob a Licença MIT - veja o arquivo `LICENSE` no repositório para mais detalhes.

## Contato

Para contato direto, envie uma mensagem para o e-mail fornecido no perfil do GitHub ou utilize as ferramentas de comunicação do próprio GitHub.
