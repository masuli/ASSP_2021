#define k0 37
#define k1 109
#define k2 109
#define k3 37
#define x 128

#include "OSAL.hh"

OPERATION(SIMDFIR4)
TRIGGER
	int input_sample_1 = UINT(1) - x;
	int input_sample_2 = UINT(2) - x;
	int input_sample_3 = UINT(3) - x;
	int input_sample_4 = UINT(4) - x;
	int d0 = UINT(5);
	int d1 = UINT(6);
	int d2 = UINT(7);
	int d3 = UINT(8);
	int filtered_sample_1;
	int filtered_sample_2;
	int filtered_sample_3;
	int filtered_sample_4;

	d0 = d1;
	d1 = d2;
	d2 = d3;
	d3 = input_sample_1;

	filtered_sample_1 = d0 * k0 + d1 * k1 + d2 * k2 + d3 * k3;
	IO(9) = (filtered_sample_1 >> 8) + x;

	d0 = d1;
	d1 = d2;
	d2 = d3;
	d3 = input_sample_2;

	filtered_sample_2 = d0 * k0 + d1 * k1 + d2 * k2 + d3 * k3;
	IO(10) = (filtered_sample_2 >> 8) + x;

	d0 = d1;
	d1 = d2;
	d2 = d3;
	d3 = input_sample_3;

	filtered_sample_3 = d0 * k0 + d1 * k1 + d2 * k2 + d3 * k3;
	IO(11) = (filtered_sample_3 >> 8) + x;

	d0 = d1;
	d1 = d2;
	d2 = d3;
	d3 = input_sample_4;

	filtered_sample_4 = d0 * k0 + d1 * k1 + d2 * k2 + d3 * k3;
	IO(12) = (filtered_sample_4 >> 8) + x;

	IO(13) = d0;
	IO(14) = d1;
	IO(15) = d2;
	IO(16) = d3;
END_TRIGGER;
END_OPERATION(SIMDFIR4)
