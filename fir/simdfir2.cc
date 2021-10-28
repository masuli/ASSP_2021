#define k0 37
#define k1 109
#define k2 109
#define k3 37
#define x 128

#include "OSAL.hh"

OPERATION(SIMDFIR)
TRIGGER
	int input_sample_1 = UINT(1) - x;
	int input_sample_2 = UINT(2) - x;
	int d0 = UINT(3);
	int d1 = UINT(4);
	int d2 = UINT(5);
	int d3 = UINT(6);
	int filtered_sample_1;
	int filtered_sample_2;

	d0 = d1;
	d1 = d2;
	d2 = d3;
	d3 = input_sample_1;

	filtered_sample_1 = d0 * k0 + d1 * k1 + d2 * k2 + d3 * k3;
	IO(7) = (filtered_sample_1 >> 8) + x;

	d0 = d1;
	d1 = d2;
	d2 = d3
	d3 = input_sample_2;

	filtered_sample_2 = d0 * k0 + d1 * k1 + d2 * k2 + d3 * k3;
	IO(8) = (filtered_sample_2 >> 8) + x;

	IO(9) = d0;
	IO(10) = d1;
	IO(11) = d2;
	IO(12) = d3;
END_TRIGGER;
END_OPERATION(SIMDFIR)
