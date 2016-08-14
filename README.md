# eistoolbox by Juan J. Montero-Rodriguez

MATLAB (R) Toolbox for fitting EIS data to circuit models

## Instructions

Run 'eistoolbox.m' to start the main program!

1. Add CSV or DTA data with the button 'Add files...'
2. Write your circuit in the dialog (based on Zfit format)
3. Select the fitting algorithm
4. Hit the 'Fit' button!
5. Save the results with the button 'Save as...'

### Input file formats

- CSV files must have three columns: FREQ,REAL,IMAG
- DTA files are from Gamry Instruments (tested Gamry 1000 Interface)

### Circuit string formats

At the moment, circuits can be written according to the Zfit specification:

-Elements can be connected in series as s(R1,R1) or in parallel as p(R1,R1), but only two elements are allowed in each. For connecting three elements in parallel, one has to write p(R1,p(R1,R1))

-All elements must include the number of fitting parameters. A resistance has one fitting parameter and therefore it is R1. A CPE has two parameters and therefore is written as E2.

-Careful! Do not treat elements as labels (i.e. R1, R2, R3... is incorrect.) The correct way is R1, R1 and R1.

-ToDo: Click the "load" button next to the fit string to load some predefined circuit examples.

-Read the source of the file Zfit.m for full documentation about circuit string formatting.



## Screenshot

![Main window of eistoolbox](https://github.com/jjmontero9/eistoolbox/blob/master/images/main_screenshot.png)

## External libraries used in this toolbox

### Zfit

The Zfit function is from Jean-Luc Dellis, [available here](https://www.mathworks.com/matlabcentral/fileexchange/19460-zfit).

More fitting functions will be available in the future (such as Levenberg-Marquardt, Nelder-Mead, BFGS, Powell). If you have more algorithm suggestions, let me know.

## License

Copyright (C) 2016  Juan J. Montero-Rodriguez
 
This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, in the version 3.

This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with this program.  If not, see <http://www.gnu.org/licenses/>.


## ToDo and development status

- [x] Read Gamry DTA files
- [x] Read CSV files in the format [FREQ,REAL,IMAG]
- [x] Fit using fminsearch (thanks to Zfit from Jean-Luc Dellis!)
- [ ] Fit using Levenberg-Marquardt
- [ ] Fit using Nelder-Mead
- [ ] Fit using BFGS
- [ ] Fit using Powell
- [ ] Simulate fitted data
- [ ] Compute correlation coefficient between source data and simulated data
- [ ] Open a new window to display the fitting results as a table, before saving them

If you have comments or suggestions, [send me an e-mail](mailto:juan.montero@tu-harburg.de)