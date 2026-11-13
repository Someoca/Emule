<!-- SPDX-License-Identifier: GPL-2.0-only -->

# Emule

Projeto experimental para executar jogos de PlayStation 5 em um PS4 com Linux,
usando o [EmuFive](https://github.com/blue0x1/EmuFive) como base e o
[KytyPS5](https://github.com/KytyPS5/KytyPS5) como camada de tradução.

O projeto e sua documentação própria estão sob a licença **GPL-2.0-only**
(identificador SPDX); o texto integral está em [`LICENSE`](LICENSE).

## Estado do projeto

Este repositório ainda não implementa emulação ou interface próprias. O EmuFive
relata executar alguns jogos de PS5 em um PS4 Pro; este projeto ainda não
verificou esses resultados localmente. Os repositórios upstream estão ligados
como submódulos em revisões fixas; a integração não altera nem copia os arquivos
deles. Esta etapa ainda não validou uma compilação ou execução em hardware PS4.

## Abordagem técnica

- O EmuFive inicia Linux no PS4 com o [PS4 Multiboot](https://github.com/blue0x1/ps4-multiboot)
  e usa uma compilação de Mesa adaptada para a GPU do console.
- O [KytyPS5 oficial](https://github.com/KytyPS5/KytyPS5) é uma camada de
  tradução de PS5 para Windows, Linux e macOS, baseada em uma versão modificada
  do Kyty. Ele executa código x86-64 dos jogos no processador hospedeiro; não
  emula integralmente a CPU do PS5.
- O EmuFive documenta patches sobre uma versão fixada do KytyPS5 para compilar
  para a CPU AMD Jaguar do PS4 (`btver2`) e traduzir instruções AVX2, FMA e BMI2
  ausentes no console. Portanto, uma compilação Linux x86-64 genérica do KytyPS5
  não basta para executá-lo no PS4.
- A GPU do PS4 também depende de suporte Vulkan específico do Mesa para o
  hardware e de recursos exigidos pelo KytyPS5. A compatibilidade e o desempenho
  precisam ser medidos no console; resultados relatados para PS4 Pro não
  garantem funcionamento em outros modelos ou em outros jogos.

## Integração e compilação

Os submódulos preservam os repositórios, históricos, avisos de autoria e
licenças upstream:

- `upstream/EmuFive`, fixado em
  [`f1df0bbc96f9dad32734ff5c86a295be9f151ee0`](https://github.com/blue0x1/EmuFive/commit/f1df0bbc96f9dad32734ff5c86a295be9f151ee0).
- `upstream/PS4-Multiboot`, fixado em
  [`3e207c2affef5a3afe04c9461b3846f40480790c`](https://github.com/blue0x1/ps4-multiboot/commit/3e207c2affef5a3afe04c9461b3846f40480790c).
- O script upstream do EmuFive baixa o KytyPS5 no commit
  `589bd14a9b8934a85e951d1aaa8112a05d62354c` e aplica os patches do próprio
  EmuFive para a CPU do PS4.

Inicialize os submódulos e compile em Linux com Bash, Git, Make, Docker e
Python 3 com Pillow (por exemplo, o pacote `python3-pil`):

```bash
git submodule update --init --recursive
bash ./scripts/build.sh
```

O script compila o Mesa para PS4 pelo PS4 Multiboot, compila o KytyPS5 para
`btver2` e gera a imagem raiz do EmuFive em
`upstream/EmuFive/out/ps5-ps4-rootfs.tar.xz`. A compilação e os testes no PS4
ainda não foram validados neste projeto.

Em pushes e pull requests, o GitHub Actions verifica os commits fixados, os
avisos de licença e a sintaxe dos scripts; também compila o KytyPS5 para
`btver2` e confere o pacote gerado. Para evitar esse custo em cada alteração,
o fluxo completo é uma opção manual (`workflow_dispatch`, `full_pipeline`):
compila Mesa, KytyPS5 e a imagem raiz, e confere arquivos essenciais nos
pacotes. Essa execução pode levar até 180 minutos; os artefatos não são
publicados nem retidos após o job. Mesmo um build completo no CI não valida a
inicialização nem a compatibilidade em um PS4 físico.

## Projetos de referência e licenças

| Projeto | Papel nesta pesquisa | Licença informada |
|---|---|---|
| [EmuFive](https://github.com/blue0x1/EmuFive) | Referência principal para PS4 com Linux; criado por Chokri Hammedi (`blue0x1`), integra KytyPS5 e patches específicos para o console. | [GPL-2.0](https://github.com/blue0x1/EmuFive/blob/main/LICENSE) |
| [KytyPS5](https://github.com/KytyPS5/KytyPS5) | Projeto upstream da camada de tradução usada pelo EmuFive. | [GPL-2.0](https://github.com/KytyPS5/KytyPS5/blob/main/LICENSE) |
| [PS4 Multiboot](https://github.com/blue0x1/ps4-multiboot) | Criado por Chokri Hammedi (`blue0x1`); inicializa Linux no PS4 e fornece a compilação de Mesa usada pelo fluxo do EmuFive. | [GPL-2.0](https://github.com/blue0x1/ps4-multiboot/blob/main/LICENSE) |
| [SharpEmu](https://github.com/sharpemu/sharpemu) | Projeto separado, escrito em C#; referência comparativa, não é o Kyty oficial nem a base escolhida. | [GPLv2](https://github.com/sharpemu/sharpemu/blob/main/LICENSE.txt); metadados do GitHub indicam GPL-2.0, enquanto o cabeçalho do README declara GPL-2.0-or-later. Confirmar os termos por arquivo antes de reutilizar código. |

O `LICENSE` deste repositório é uma cópia literal do texto GPLv2 usado pelo
EmuFive e pelo PS4 Multiboot (o mesmo objeto Git nos dois projetos). O
identificador SPDX `GPL-2.0-only` especifica a versão 2, sem a opção “ou
qualquer versão posterior”. Ao distribuir binários, também será necessário
fornecer o código-fonte correspondente e os scripts de compilação/instalação
exigidos pela licença.

Este projeto não inclui jogos, firmware ou outros arquivos proprietários da
Sony. Use somente jogos obtidos legalmente.

## Referências

- [EmuFive: como funciona e limitações da CPU](https://github.com/blue0x1/EmuFive#how-it-works)
- [KytyPS5: requisitos e compilação para Linux](https://github.com/KytyPS5/KytyPS5#building-on-linux)
- [SharpEmu](https://github.com/sharpemu/sharpemu)
